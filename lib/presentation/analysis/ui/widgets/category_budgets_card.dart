import 'package:finance_app/domain/models/category_budget_progress.dart';
import 'package:finance_app/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/analysis_theme.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Per-category budget ("max") vs. actual spend for the month, with a progress
/// bar and percentage per category. Tap a row to change that category's budget.
/// Purely presentational — edits go through [AnalysisBloc] via
/// [UpdateCategoryBudget].
class CategoryBudgetsCard extends StatelessWidget {
  final AnalysisData data;

  const CategoryBudgetsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final rows = data.categoryBudgets;
    return AnalysisCard(
      padding: rows.isEmpty
          ? const EdgeInsets.all(AppSpacing.lg)
          : const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalysisCardHeader(
            icon: Icons.donut_small_outlined,
            title: AppStrings.budgetsTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                AppStrings.budgetsEmpty,
                style: AnalysisTokens.bodyMuted(),
              ),
            )
          else
            for (final row in rows)
              _CategoryRow(
                row: row,
                onEdit: () => _showEditDialog(context, row),
              ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    CategoryBudgetProgress row,
  ) async {
    final controller = TextEditingController(
      text: row.hasBudget ? row.max.round().toString() : '',
    );
    final bloc = context.read<AnalysisBloc>();

    final value = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AnalysisTokens.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AnalysisTokens.radiusLg),
              ),
              title: Text(row.title, style: AnalysisTokens.heading()),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.budgetDialogHint,
                  errorText: errorText,
                  filled: true,
                  fillColor: AnalysisTokens.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AnalysisTokens.radiusMd,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AnalysisTokens.radiusMd,
                    ),
                    borderSide: BorderSide(color: AnalysisTokens.accent),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    AppStrings.cancel,
                    style: AnalysisTokens.bodyMuted(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final parsed = double.tryParse(controller.text.trim());
                    if (parsed == null || parsed < 0) {
                      setState(
                        () => errorText = AppStrings.budgetInvalidAmount,
                      );
                      return;
                    }
                    Navigator.of(dialogContext).pop(parsed);
                  },
                  child: Text(
                    AppStrings.save,
                    style: AppTextStyle.bold16().copyWith(
                      color: AnalysisTokens.accent,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (value != null) {
      bloc.add(AnalysisEvent.updateCategoryBudget(row.categoryId, value));
    }
  }
}

class _CategoryRow extends StatelessWidget {
  final CategoryBudgetProgress row;
  final VoidCallback onEdit;

  const _CategoryRow({required this.row, required this.onEdit});

  static final NumberFormat _fmt = NumberFormat('#,##0');

  Color get _accent {
    if (!row.hasBudget) return AnalysisTokens.textTertiary;
    if (row.isOverBudget) return AnalysisTokens.danger;
    return row.ratio <= 0.8 ? AnalysisTokens.positive : AnalysisTokens.warning;
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent;
    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(AnalysisTokens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  padding: const EdgeInsets.all(AppSpacing.xs + 1),
                  decoration: BoxDecoration(
                    color: AnalysisTokens.background,
                    borderRadius: BorderRadius.circular(
                      AnalysisTokens.radiusMd,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/${row.icon}.png',
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.category_outlined,
                      color: AnalysisTokens.accent,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Text(
                    row.title,
                    style: AnalysisTokens.body().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _trailing(accent),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AnalysisTokens.radiusPill),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
                tween: Tween(
                  begin: 0,
                  end: row.hasBudget
                      ? row.ratio.clamp(0.0, 1.0).toDouble()
                      : 0.0,
                ),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: AnalysisTokens.track,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
            ),
            if (row.hasBudget) ...[
              const SizedBox(height: AppSpacing.xs + 2),
              Text(
                row.isOverBudget
                    ? '${_fmt.format(row.spent - row.max)} ${AppStrings.budgetOverBy}'
                    : '${_fmt.format(row.max - row.spent)} ${AppStrings.budgetRemaining}',
                style: AnalysisTokens.label().copyWith(
                  color: row.isOverBudget
                      ? AnalysisTokens.danger
                      : AnalysisTokens.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _trailing(Color accent) {
    if (!row.hasBudget) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AnalysisTokens.accentSoft,
          borderRadius: BorderRadius.circular(AnalysisTokens.radiusPill),
        ),
        child: Text(
          AppStrings.budgetSet,
          style: AppTextStyle.body14Medium().copyWith(
            color: AnalysisTokens.accent,
            fontSize: 12,
          ),
        ),
      );
    }
    final percent = (row.ratio * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${_fmt.format(row.spent)} / ${_fmt.format(row.max)}',
          style: AnalysisTokens.bodyMuted(),
        ),
        Text('$percent%', style: AppTextStyle.bold14().copyWith(color: accent)),
      ],
    );
  }
}
