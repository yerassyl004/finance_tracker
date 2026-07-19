import 'package:finance_app/domain/models/financial_analysis.dart';
import 'package:finance_app/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/analysis_theme.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// "AI Insights" card shown inside the Analysis page.
///
/// Renders one of four states from [AnalysisData]: idle (prompt to generate),
/// loading, error (with retry), or a parsed [FinancialAnalysis] with a health
/// score and a list of recommendations. Purely presentational — all work is
/// delegated to [AnalysisBloc] via [LoadAiInsights].
class AiInsightsCard extends StatelessWidget {
  final AnalysisData data;

  const AiInsightsCard({super.key, required this.data});

  void _generate(BuildContext context, {bool forceRefresh = false}) {
    context.read<AnalysisBloc>().add(
      AnalysisEvent.loadAiInsights(forceRefresh: forceRefresh),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analysis = data.aiAnalysis;
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalysisCardHeader(
            icon: Icons.auto_awesome_outlined,
            title: AppStrings.aiInsightsTitle,
            trailing: data.aiLoading
                ? const _HeaderSpinner()
                : (analysis != null
                      ? _RefreshButton(
                          onTap: () => _generate(context, forceRefresh: true),
                        )
                      : null),
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _buildBody(context, analysis),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, FinancialAnalysis? analysis) {
    // Keep an existing analysis on screen while refreshing (the header shows a
    // spinner); only show the full loading state on the very first generation.
    if (analysis != null) {
      return _AiResult(key: const ValueKey('ai-result'), analysis: analysis);
    }
    if (data.aiLoading) {
      return const _AiLoading(key: ValueKey('ai-loading'));
    }
    if (data.aiError != null) {
      return _AiMessage(
        key: const ValueKey('ai-error'),
        message: data.aiError!,
        isError: true,
        onAction: () => _generate(context, forceRefresh: true),
      );
    }
    return _AiMessage(
      key: const ValueKey('ai-idle'),
      message: AppStrings.aiInsightsSubtitle,
      isError: false,
      onAction: () => _generate(context, forceRefresh: true),
    );
  }
}

/// Small spinner shown in the card header while insights refresh in place.
class _HeaderSpinner extends StatelessWidget {
  const _HeaderSpinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AnalysisTokens.accent,
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RefreshButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AnalysisTokens.accent,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(Icons.refresh, size: 18),
      label: Text(
        AppStrings.aiRegenerate,
        style: AppTextStyle.body14Medium().copyWith(
          color: AnalysisTokens.accent,
        ),
      ),
    );
  }
}

class _AiLoading extends StatelessWidget {
  const _AiLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AnalysisTokens.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(AppStrings.aiLoading, style: AnalysisTokens.bodyMuted()),
        ],
      ),
    );
  }
}

/// Idle prompt or error message, each with a primary call-to-action button.
class _AiMessage extends StatelessWidget {
  final String message;
  final bool isError;
  final VoidCallback onAction;

  const _AiMessage({
    super.key,
    required this.message,
    required this.isError,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isError) ...[
              Icon(Icons.error_outline, size: 18, color: AnalysisTokens.danger),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                message,
                style: isError
                    ? AnalysisTokens.body().copyWith(
                        color: AnalysisTokens.danger,
                      )
                    : AnalysisTokens.bodyMuted(),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _PrimaryButton(label: AppStrings.aiGenerate, onTap: onAction),
      ],
    );
  }
}

class _AiResult extends StatelessWidget {
  final FinancialAnalysis analysis;

  const _AiResult({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (analysis.summary.isNotEmpty)
          Text(analysis.summary, style: AnalysisTokens.body()),
        if (analysis.healthScore != null) ...[
          const SizedBox(height: AppSpacing.md),
          _HealthScoreBar(score: analysis.healthScore!),
        ],
        if (analysis.recommendations.isNotEmpty)
          const SizedBox(height: AppSpacing.md),
        for (final r in analysis.recommendations)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
            child: _RecommendationTile(recommendation: r),
          ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnalysisTokens.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AnalysisTokens.radiusMd),
          ),
        ),
        icon: const Icon(Icons.auto_awesome_outlined, size: 18),
        label: Text(
          label,
          style: AppTextStyle.bold16().copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

/// Horizontal 0-100 bar visualising the AI's estimated financial-health score.
class _HealthScoreBar extends StatelessWidget {
  final double score;

  const _HealthScoreBar({required this.score});

  @override
  Widget build(BuildContext context) {
    final clamped = score.clamp(0, 100).toDouble();
    final color = clamped >= 70
        ? AnalysisTokens.positive
        : clamped >= 40
        ? AnalysisTokens.warning
        : AnalysisTokens.danger;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.aiHealthScore, style: AnalysisTokens.bodyMuted()),
            Text(
              '${clamped.toStringAsFixed(0)}/100',
              style: AppTextStyle.bold16().copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AnalysisTokens.radiusPill),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            tween: Tween(begin: 0, end: clamped / 100),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: AnalysisTokens.track,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

/// A single recommendation with a severity-coloured accent bar and dot.
class _RecommendationTile extends StatelessWidget {
  final FinancialRecommendation recommendation;

  const _RecommendationTile({required this.recommendation});

  Color _accent() {
    switch (recommendation.severity) {
      case RecommendationSeverity.positive:
        return AnalysisTokens.positive;
      case RecommendationSeverity.info:
        return AnalysisTokens.accent;
      case RecommendationSeverity.warning:
        return AnalysisTokens.warning;
      case RecommendationSeverity.critical:
        return AnalysisTokens.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AnalysisTokens.radiusMd),
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  recommendation.title,
                  style: AppTextStyle.bold14().copyWith(
                    color: AnalysisTokens.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (recommendation.detail.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(recommendation.detail, style: AnalysisTokens.bodyMuted()),
          ],
        ],
      ),
    );
  }
}
