import 'package:finance_app/domain/models/category_budget_progress.dart';
import 'package:finance_app/domain/models/financial_profile.dart';

/// Inputs the AI needs to reason about the user's finances: their onboarding
/// profile (income, fixed costs, goal) plus per-category budget-vs-actual
/// spend for the period being analysed.
///
/// Lives beside the result model (rather than in the use case) so both the
/// `Repository` and the use case can reference it without a circular import.
class FinancialAnalysisArguments {
  final FinancialProfile profile;

  /// Per-category budget ("max") vs. actual spend for the current period. This
  /// is the primary signal the AI reasons over for category-level warnings.
  final List<CategoryBudgetProgress> categoryBudgets;

  final double totalExpense;
  final double totalIncome;

  /// The month the analysis covers; part of the cache [fingerprint] so a new
  /// month regenerates rather than reusing last month's advice.
  final DateTime month;

  /// When true, skip the cache and force a fresh Gemini call (the "refresh"
  /// button). Not part of the fingerprint.
  final bool forceRefresh;

  /// When true, a cache miss triggers a fresh Gemini call; when false, a miss
  /// simply returns whatever is cached (or nothing), spending no tokens. The
  /// presentation layer sets this to true only for the current month, so
  /// browsing past months never auto-generates.
  final bool autoGenerateOnMiss;

  const FinancialAnalysisArguments({
    required this.profile,
    required this.totalExpense,
    required this.totalIncome,
    required this.month,
    this.categoryBudgets = const [],
    this.forceRefresh = false,
    this.autoGenerateOnMiss = true,
  });

  /// Stable per-month cache key (e.g. `2026-07`). One cached analysis is kept
  /// per month so switching months reuses each month's result instead of
  /// evicting a single shared slot.
  String get monthKey =>
      '${month.year.toString().padLeft(4, '0')}-'
      '${month.month.toString().padLeft(2, '0')}';

  /// A stable hash of every input the analysis depends on. Two argument sets
  /// with the same fingerprint would produce equivalent advice, so a cached
  /// result with a matching fingerprint can be reused (saving Gemini tokens).
  ///
  /// Amounts are rounded to whole currency units so trivial sub-unit changes
  /// don't invalidate the cache.
  String get fingerprint {
    String money(double v) => v.round().toString();

    final rows =
        categoryBudgets
            .map((c) => '${c.categoryId}:${money(c.spent)}/${money(c.max)}')
            .toList()
          ..sort();

    final canonical = [
      '${month.year}-${month.month}',
      profile.currencyCode,
      profile.goal?.name ?? '-',
      profile.payFrequency.name,
      money(profile.salary),
      money(profile.otherIncome),
      money(profile.housePayment),
      money(profile.carPayment),
      money(profile.utilitiesPayment),
      'exp=${money(totalExpense)}',
      'inc=${money(totalIncome)}',
      rows.join(','),
    ].join('|');

    return _fnv1a(canonical);
  }

  /// Small, dependency-free FNV-1a hash. Deterministic across runs (unlike
  /// `String.hashCode`), so a persisted fingerprint stays comparable.
  static String _fnv1a(String input) {
    var hash = 0x811c9dc5;
    for (final code in input.codeUnits) {
      hash ^= code;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}

/// A cached [FinancialAnalysis] together with the [fingerprint] of the inputs
/// it was generated from and when it was produced.
class CachedFinancialAnalysis {
  final FinancialAnalysis analysis;
  final String fingerprint;
  final DateTime updatedAt;

  const CachedFinancialAnalysis({
    required this.analysis,
    required this.fingerprint,
    required this.updatedAt,
  });
}

/// How urgent/important a single AI recommendation is.
///
/// Drives the accent colour of the recommendation card in the UI. Kept in the
/// domain layer (no Flutter dependency) so it can be mapped to colours in
/// presentation.
enum RecommendationSeverity {
  /// Neutral observation or reinforcement of good behaviour.
  positive,

  /// General suggestion worth acting on but not urgent.
  info,

  /// Something the user should address soon (e.g. over budget).
  warning,

  /// A serious issue (e.g. spending exceeds income).
  critical;

  /// Parses a severity from the string Gemini returns, defaulting to [info]
  /// for any unexpected value so a single odd token can't break the whole
  /// response.
  static RecommendationSeverity fromName(String? name) {
    for (final severity in RecommendationSeverity.values) {
      if (severity.name == name) return severity;
    }
    return RecommendationSeverity.info;
  }
}

/// A single, actionable recommendation produced by the AI analysis.
class FinancialRecommendation {
  /// Short headline (e.g. "Trim dining out").
  final String title;

  /// One or two sentences explaining the recommendation.
  final String detail;

  final RecommendationSeverity severity;

  /// Optional category id/name this recommendation relates to, when the model
  /// ties the advice to a specific spending category.
  final String? category;

  const FinancialRecommendation({
    required this.title,
    required this.detail,
    required this.severity,
    this.category,
  });

  factory FinancialRecommendation.fromJson(Map<String, dynamic> json) {
    return FinancialRecommendation(
      title: (json['title'] as String?)?.trim() ?? '',
      detail: (json['detail'] as String?)?.trim() ?? '',
      severity: RecommendationSeverity.fromName(json['severity'] as String?),
      category: (json['category'] as String?)?.trim(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'detail': detail,
    'severity': severity.name,
    'category': category,
  };
}

/// Structured, parsed result of a Gemini financial analysis.
///
/// This is intentionally a plain, serializable value object: the remote data
/// source asks Gemini for JSON matching this shape and parses it here, so the
/// rest of the app never touches raw model output.
class FinancialAnalysis {
  /// A short natural-language summary of the user's financial picture.
  final String summary;

  /// Overall financial-health score in the range 0-100, or null if the model
  /// did not provide one.
  final double? healthScore;

  /// Ordered list of actionable recommendations (most important first).
  final List<FinancialRecommendation> recommendations;

  const FinancialAnalysis({
    required this.summary,
    required this.recommendations,
    this.healthScore,
  });

  factory FinancialAnalysis.fromJson(Map<String, dynamic> json) {
    final rawRecommendations = json['recommendations'];
    final recommendations = <FinancialRecommendation>[];
    if (rawRecommendations is List) {
      for (final item in rawRecommendations) {
        if (item is Map<String, dynamic>) {
          recommendations.add(FinancialRecommendation.fromJson(item));
        }
      }
    }

    final rawScore = json['healthScore'];
    return FinancialAnalysis(
      summary: (json['summary'] as String?)?.trim() ?? '',
      healthScore: rawScore is num ? rawScore.toDouble() : null,
      recommendations: recommendations,
    );
  }

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'healthScore': healthScore,
    'recommendations': recommendations.map((r) => r.toJson()).toList(),
  };
}
