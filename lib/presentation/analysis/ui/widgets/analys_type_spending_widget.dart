import 'package:finance_app/domain/models/type_spending.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/analysis_theme.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';

/// One segment of the Expense / Income segmented control. When selected it
/// becomes a white "thumb" with a soft shadow and accent text; otherwise it is
/// a muted, transparent label. Public API is unchanged.
class AnalysTypeSpendingWidget extends StatelessWidget {
  final TypeSpending typeSpending;
  final bool isSelected;
  final Function(TypeSpending) onTap;

  const AnalysTypeSpendingWidget({
    super.key,
    required this.typeSpending,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = typeSpending == TypeSpending.expense
        ? AppStrings.expenseText
        : AppStrings.incomeText;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(typeSpending),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minWidth: 108, minHeight: 40),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AnalysisTokens.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AnalysisTokens.radiusPill),
          boxShadow: isSelected ? AnalysisTokens.softShadow : null,
        ),
        child: Text(
          label,
          style: AppTextStyle.body16Medium().copyWith(
            color: isSelected
                ? AnalysisTokens.accent
                : AnalysisTokens.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
