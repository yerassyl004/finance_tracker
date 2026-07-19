import 'dart:convert';
import 'dart:io';

import 'package:finance_app/domain/models/financial_analysis.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// The kinds of failure the Gemini layer can surface, so the repository can map
/// each to a distinct, user-facing [Failure] code/message.
enum GeminiErrorType {
  /// No API key was provided at build time (`--dart-define=GEMINI_API_KEY`).
  missingApiKey,

  /// The key was rejected by Google.
  invalidApiKey,

  /// Device is offline / the request could not reach the API.
  offline,

  /// Quota exhausted or requests throttled (HTTP 429).
  rateLimited,

  /// The model responded but the payload could not be parsed.
  badResponse,

  /// Anything else (server errors, unexpected exceptions).
  unknown,
}

/// Typed exception thrown by [GeminiRemoteDataSource]; carries a
/// [GeminiErrorType] the repository translates into a `Failure`.
class GeminiException implements Exception {
  final GeminiErrorType type;
  final String message;

  GeminiException(this.type, this.message);

  @override
  String toString() => 'GeminiException($type): $message';
}

/// Remote data source that turns the user's financial profile and actual
/// spending into a structured [FinancialAnalysis] via a Gemini Flash model.
///
/// The API key is injected at build time and never hardcoded:
/// `flutter run --dart-define=GEMINI_API_KEY=<key>`.
class GeminiRemoteDataSource {
  /// The key read from the compile-time environment. Empty when not supplied.
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// A current Gemini Flash model. `-latest` keeps us on the newest Flash
  /// revision without pinning a version that will eventually be retired.
  static const String _modelName = 'gemini-flash-latest';

  /// True when a key is available; lets the UI hide/disable the feature
  /// gracefully instead of firing a request that is guaranteed to fail.
  bool get isConfigured => _apiKey.isNotEmpty;

  /// Builds a model per call so `generationConfig` / `systemInstruction` stay
  /// request-local; cheap because the SDK does no network work at construction.
  GenerativeModel _model() {
    return GenerativeModel(
      model: _modelName,
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        // Ask the API for JSON so we parse structured data, not free text.
        responseMimeType: 'application/json',
        temperature: 0.4,
      ),
      systemInstruction: Content.system(_systemPrompt),
    );
  }

  Future<FinancialAnalysis> getAnalysis(FinancialAnalysisArguments args) async {
    if (!isConfigured) {
      throw GeminiException(
        GeminiErrorType.missingApiKey,
        'No Gemini API key configured.',
      );
    }

    try {
      final response = await _model().generateContent([
        Content.text(_buildUserPrompt(args)),
      ]);

      final text = response.text;
      if (text == null || text.trim().isEmpty) {
        throw GeminiException(
          GeminiErrorType.badResponse,
          'Empty response from Gemini.',
        );
      }
      return _parse(text);
    } on GeminiException {
      rethrow;
    } on InvalidApiKey catch (e) {
      throw GeminiException(GeminiErrorType.invalidApiKey, e.message);
    } on ServerException catch (e) {
      // The SDK surfaces quota/rate-limit issues as server exceptions.
      final message = e.message.toLowerCase();
      final isRateLimit =
          message.contains('429') ||
          message.contains('quota') ||
          message.contains('rate');
      throw GeminiException(
        isRateLimit ? GeminiErrorType.rateLimited : GeminiErrorType.unknown,
        e.message,
      );
    } on GenerativeAIException catch (e) {
      throw GeminiException(GeminiErrorType.unknown, e.message);
    } on SocketException catch (e) {
      throw GeminiException(GeminiErrorType.offline, e.message);
    } on FormatException catch (e) {
      throw GeminiException(GeminiErrorType.badResponse, e.message);
    }
  }

  /// Parses Gemini's JSON text into the domain model, tolerating the model
  /// occasionally wrapping JSON in stray prose or markdown fences.
  FinancialAnalysis _parse(String text) {
    final jsonString = _extractJson(text);
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw GeminiException(
        GeminiErrorType.badResponse,
        'Expected a JSON object from Gemini.',
      );
    }
    return FinancialAnalysis.fromJson(decoded);
  }

  /// Returns the substring between the first `{` and last `}` so a fenced or
  /// prefixed response still parses.
  String _extractJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end == -1 || end <= start) {
      throw GeminiException(
        GeminiErrorType.badResponse,
        'No JSON object found in response.',
      );
    }
    return text.substring(start, end + 1);
  }

  /// System instruction: defines the assistant's role and the exact JSON shape
  /// we parse in [FinancialAnalysis.fromJson].
  static const String _systemPrompt = '''
You are a practical personal-finance assistant inside a budgeting app, similar
to Mint, YNAB or Copilot. Your job is to analyse each expense category against
the budget ("max") the user set for it, plus their income and fixed costs, and
return concrete, encouraging, category-aware recommendations.

Respond with ONLY a JSON object (no markdown, no prose) of this exact shape:
{
  "summary": "one or two short sentences describing their overall picture",
  "healthScore": <number 0-100 estimating overall financial health>,
  "recommendations": [
    {
      "title": "short headline",
      "detail": "one or two sentences of concrete, actionable advice",
      "severity": "positive | info | warning | critical",
      "category": "related category name, or omit for overall advice"
    }
  ]
}

Analysis rules (decide severity yourself, like a good budgeting app would):
- For EACH category that is over its budget, add a recommendation: set
  "critical" when it is far over (roughly >120% of budget) or the overspend is
  large relative to income, otherwise "warning". Say how much over it is and
  give a specific way to cut back.
- Flag categories approaching their budget (roughly 80-100%) as "info" so the
  user can slow down before overspending.
- Reinforce categories comfortably under budget with a "positive" note.
- If total expenses exceed income, that is the single most important "critical"
  recommendation.
- Consider the user's stated goal and fixed costs when prioritising.
- Provide 3 to 6 recommendations, most important first. Use the exact category
  name from the data in the "category" field.
- Keep every string plain text, no markdown.''';

  /// Serialises the user's numbers into a compact prompt the model can reason
  /// over. Amounts are rounded to keep the prompt small and deterministic.
  String _buildUserPrompt(FinancialAnalysisArguments args) {
    final profile = args.profile;
    final buffer = StringBuffer()
      ..writeln('Currency: ${profile.currencyCode}')
      ..writeln('Primary goal: ${profile.goal?.label ?? 'not set'}')
      ..writeln('Pay frequency: ${profile.payFrequency.label}')
      ..writeln('Monthly salary: ${_money(profile.salary)}')
      ..writeln('Other monthly income: ${_money(profile.otherIncome)}')
      ..writeln('Total monthly income: ${_money(profile.totalIncome)}')
      ..writeln(
        'Fixed costs — house/rent: ${_money(profile.housePayment)}, '
        'car/loan: ${_money(profile.carPayment)}, '
        'utilities: ${_money(profile.utilitiesPayment)} '
        '(total ${_money(profile.fixedExpenses)})',
      )
      ..writeln(
        'Total actual expenses this period: '
        '${_money(args.totalExpense)}',
      )
      ..writeln(
        'Total actual income this period: '
        '${_money(args.totalIncome)}',
      );

    buffer.writeln('\nPer-category budget (max) vs. actual spend this month:');
    if (args.categoryBudgets.isEmpty) {
      buffer.writeln('(no category data provided)');
    } else {
      for (final c in args.categoryBudgets) {
        if (c.hasBudget) {
          final percent = (c.ratio * 100).round();
          final status = c.isOverBudget
              ? ' [OVER BUDGET by ${_money(c.spent - c.max)}]'
              : '';
          buffer.writeln(
            '- ${c.title}: budget ${_money(c.max)}, '
            'spent ${_money(c.spent)} ($percent% of budget)$status',
          );
        } else {
          buffer.writeln(
            '- ${c.title}: no budget set, spent ${_money(c.spent)}',
          );
        }
      }
    }
    return buffer.toString();
  }

  String _money(double value) => value.toStringAsFixed(0);
}
