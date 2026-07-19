import 'package:finance_app/domain/models/category_budget_progress.dart';
import 'package:finance_app/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
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
          Text(AppStrings.budgetsTitle, style: AppTextStyle.body20Medium()),
          const SizedBox(height: 12),
          if (rows.isEmpty)
            Text(
              AppStrings.budgetsEmpty,
              style: AppTextStyle.body14Medium().copyWith(
                color: ColorManager.grey,
              ),
            )
          else
            ...rows.map(
              (row) => _CategoryRow(
                row: row,
                onEdit: () => _showEditDialog(context, row),
              ),
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
              backgroundColor: ColorManager.white,
              title: Text(row.title, style: AppTextStyle.bold20()),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.budgetDialogHint,
                  errorText: errorText,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    AppStrings.cancel,
                    style: AppTextStyle.body16Medium().copyWith(
                      color: ColorManager.grey,
                    ),
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
                      color: ColorManager.primary,
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
    if (!row.hasBudget) return ColorManager.grey;
    if (row.isOverBudget) return ColorManager.error;
    return row.ratio <= 0.8 ? Colors.green.shade600 : Colors.orange.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent;
    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/${row.icon}.png',
                  width: 28,
                  height: 28,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.category,
                    color: ColorManager.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(row.title, style: AppTextStyle.body16Medium()),
                ),
                _trailing(accent),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: row.hasBudget
                    ? row.ratio.clamp(0.0, 1.0).toDouble()
                    : 0.0,
                minHeight: 7,
                backgroundColor: ColorManager.lightGrey.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
            if (row.hasBudget) ...[
              const SizedBox(height: 4),
              Text(
                row.isOverBudget
                    ? '${_fmt.format(row.spent - row.max)} ${AppStrings.budgetOverBy}'
                    : '${_fmt.format(row.max - row.spent)} ${AppStrings.budgetRemaining}',
                style: AppTextStyle.body14Medium().copyWith(
                  color: row.isOverBudget
                      ? ColorManager.error
                      : ColorManager.grey,
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
      return Row(
        children: [
          Text(_fmt.format(row.spent), style: AppTextStyle.body16Medium()),
          const SizedBox(width: 6),
          Text(
            AppStrings.budgetSet,
            style: AppTextStyle.body14Medium().copyWith(
              color: ColorManager.primary,
            ),
          ),
        ],
      );
    }
    final percent = (row.ratio * 100).round();
    return RichText(
      textAlign: TextAlign.end,
      text: TextSpan(
        style: AppTextStyle.body16Medium(),
        children: [
          TextSpan(text: '${_fmt.format(row.spent)} / ${_fmt.format(row.max)}'),
          TextSpan(
            text: '  $percent%',
            style: AppTextStyle.bold16().copyWith(color: accent),
          ),
        ],
      ),
    );
  }
}
