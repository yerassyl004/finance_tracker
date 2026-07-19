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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NavButton(
                icon: Icons.chevron_left,
                tooltip: 'Previous month',
                onTap: _previousMonth,
              ),
              SizedBox(
                width: 190,
                child: Text(
                  monthYear,
                  textAlign: TextAlign.center,
                  style: AnalysisTokens.heading(),
                ),
              ),
              _NavButton(
                icon: Icons.chevron_right,
                tooltip: 'Next month',
                onTap: _nextMonth,
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

/// Subtle, touch-friendly circular icon button for month navigation.
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      iconSize: 22,
      color: AnalysisTokens.textSecondary,
      splashRadius: 22,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: Icon(icon),
    );
  }
}
