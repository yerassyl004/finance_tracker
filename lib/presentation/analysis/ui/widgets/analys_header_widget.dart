import 'package:finance_app/presentation/analysis/ui/widgets/analys_type_spending_widget.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/analysis_theme.dart';
import 'package:finance_app/domain/models/type_spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalysHeaderWidget extends StatelessWidget {
  final Function(DateTime) onDateChanged;
  final Function(TypeSpending) typeSpending;
  final DateTime currentDate;
  final TypeSpending selectedType;

  const AnalysHeaderWidget({
    super.key,
    required this.onDateChanged,
    required this.typeSpending,
    required this.currentDate,
    required this.selectedType,
  });

  void _previousMonth() {
    onDateChanged(DateTime(currentDate.year, currentDate.month - 1));
  }

  void _nextMonth() {
    onDateChanged(DateTime(currentDate.year, currentDate.month + 1));
  }

  void _onSelectedType(TypeSpending typeSpending) {
    this.typeSpending(typeSpending);
  }

  @override
  Widget build(BuildContext context) {
    final monthYear = DateFormat('MMMM yyyy').format(currentDate);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AnalysisTokens.background,
        border: Border(bottom: BorderSide(color: AnalysisTokens.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month switcher.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ChevronButton(
                icon: Icons.chevron_left,
                onTap: _previousMonth,
                semanticLabel: 'Previous month',
              ),
              Expanded(
                child: Text(
                  monthYear,
                  textAlign: TextAlign.center,
                  style: AnalysisTokens.heading(),
                ),
              ),
              _ChevronButton(
                icon: Icons.chevron_right,
                onTap: _nextMonth,
                semanticLabel: 'Next month',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Expense / Income segmented control.
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AnalysisTokens.track,
              borderRadius: BorderRadius.circular(AnalysisTokens.radiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnalysTypeSpendingWidget(
                  typeSpending: TypeSpending.expense,
                  isSelected: selectedType == TypeSpending.expense,
                  onTap: _onSelectedType,
                ),
                AnalysTypeSpendingWidget(
                  typeSpending: TypeSpending.income,
                  isSelected: selectedType == TypeSpending.income,
                  onTap: _onSelectedType,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChevronButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  const _ChevronButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Material(
          color: AnalysisTokens.track,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Icon(icon, size: 22, color: AnalysisTokens.textSecondary),
          ),
        ),
      ),
    );
  }
}
