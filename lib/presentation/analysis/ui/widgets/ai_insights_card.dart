import 'package:finance_app/domain/models/financial_analysis.dart';
import 'package:finance_app/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: ColorManager.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                AppStrings.aiInsightsTitle,
                style: AppTextStyle.body20Medium(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (data.aiLoading)
            _buildLoading()
          else if (data.aiError != null)
            _buildError(context, data.aiError!)
          else if (analysis != null)
            _buildAnalysis(context, analysis)
          else
            _buildIdle(context),
        ],
      ),
    );
  }

  Widget _buildIdle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.aiInsightsSubtitle,
          style: AppTextStyle.body14Medium().copyWith(color: ColorManager.grey),
        ),
        const SizedBox(height: 16),
        _primaryButton(context, AppStrings.aiGenerate),
      ],
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(AppStrings.aiLoading, style: AppTextStyle.body14Medium()),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: ColorManager.error, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: AppTextStyle.body14Medium().copyWith(
                  color: ColorManager.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _primaryButton(context, AppStrings.aiGenerate),
      ],
    );
  }

  Widget _buildAnalysis(BuildContext context, FinancialAnalysis analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (analysis.summary.isNotEmpty)
          Text(analysis.summary, style: AppTextStyle.body16Regular()),
        if (analysis.healthScore != null) ...[
          const SizedBox(height: 16),
          _HealthScoreBar(score: analysis.healthScore!),
        ],
        const SizedBox(height: 16),
        ...analysis.recommendations.map(
          (recommendation) =>
              _RecommendationTile(recommendation: recommendation),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _generate(context, forceRefresh: true),
            icon: Icon(Icons.refresh, size: 18, color: ColorManager.primary),
            label: Text(
              AppStrings.aiRegenerate,
              style: AppTextStyle.body14Medium().copyWith(
                color: ColorManager.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _primaryButton(BuildContext context, String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _generate(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(Icons.auto_awesome, size: 18, color: ColorManager.white),
        label: Text(
          label,
          style: AppTextStyle.bold16().copyWith(color: ColorManager.white),
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
        ? Colors.green.shade600
        : clamped >= 40
        ? Colors.orange.shade700
        : ColorManager.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.aiHealthScore, style: AppTextStyle.body14Medium()),
            Text(
              '${clamped.toStringAsFixed(0)}/100',
              style: AppTextStyle.bold16().copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: clamped / 100,
            minHeight: 8,
            backgroundColor: ColorManager.lightGrey.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

/// A single recommendation row with a severity-coloured accent bar.
class _RecommendationTile extends StatelessWidget {
  final FinancialRecommendation recommendation;

  const _RecommendationTile({required this.recommendation});

  Color _accent() {
    switch (recommendation.severity) {
      case RecommendationSeverity.positive:
        return Colors.green.shade600;
      case RecommendationSeverity.info:
        return ColorManager.primary;
      case RecommendationSeverity.warning:
        return Colors.orange.shade700;
      case RecommendationSeverity.critical:
        return ColorManager.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recommendation.title,
            style: AppTextStyle.bold16().copyWith(color: accent),
          ),
          if (recommendation.detail.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(recommendation.detail, style: AppTextStyle.body14Medium()),
          ],
        ],
      ),
    );
  }
}
