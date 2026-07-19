import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/presentation/home/widgets/categories_widgets.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HeaderPreferred extends StatelessWidget implements PreferredSizeWidget {
  final List<Transaction> transactionsFuture;
  final Function(DateTime) onDateChanged;
  final double expenseAmount;
  final double incomeAmount;
  final DateTime currentDate;

  const HeaderPreferred({
    super.key,
    required this.transactionsFuture,
    required this.onDateChanged,
    required this.expenseAmount,
    required this.incomeAmount,
    required this.currentDate,
  });

  void _previousMonth() {
    onDateChanged(DateTime(currentDate.year, currentDate.month - 1));
  }

  void _nextMonth() {
    onDateChanged(DateTime(currentDate.year, currentDate.month + 1));
  }

  @override
  Size get preferredSize => Size.fromHeight(244.h);

  @override
  Widget build(BuildContext context) {
    final total = incomeAmount - expenseAmount;
    final monthYear = DateFormat('MMMM yyyy').format(currentDate);
    final balanceColor = total < 0 ? HomeTokens.danger : HomeTokens.textPrimary;
    final sign = total < 0 ? '−' : '';
    final balanceText = '$sign₸${total.abs().toStringAsFixed(2)}';

    return PreferredSize(
      preferredSize: preferredSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: HomeTokens.surface,
          border: const Border(bottom: BorderSide(color: HomeTokens.border)),
          boxShadow: HomeTokens.softShadow,
        ),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: HomeTokens.contentMaxWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  HomeSpacing.md,
                  HomeSpacing.sm,
                  HomeSpacing.md,
                  HomeSpacing.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _MonthSwitcher(
                      label: monthYear,
                      onPrevious: _previousMonth,
                      onNext: _nextMonth,
                    ),
                    const SizedBox(height: HomeSpacing.sm),
                    Column(
                      children: [
                        Text(AppStrings.balanceText, style: HomeTokens.label()),
                        const SizedBox(height: HomeSpacing.xs),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            balanceText,
                            style: HomeTokens.metricHero().copyWith(
                              color: balanceColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: HomeSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: CategoriesWidgets(
                            category: AppStrings.incomeText,
                            cash: incomeAmount.toStringAsFixed(2),
                            color: HomeTokens.positive,
                          ),
                        ),
                        const SizedBox(width: HomeSpacing.sm + HomeSpacing.xs),
                        Expanded(
                          child: CategoriesWidgets(
                            category: AppStrings.expenseText,
                            cash: expenseAmount.toStringAsFixed(2),
                            color: HomeTokens.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact, ghost-style month navigator: two low-emphasis chevron targets
/// (≥48px) flanking a centred month label.
class _MonthSwitcher extends StatelessWidget {
  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthSwitcher({
    required this.label,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ChevronButton(
          icon: Icons.chevron_left,
          onTap: onPrevious,
          semanticLabel: 'Previous month',
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: HomeTokens.heading(),
          ),
        ),
        _ChevronButton(
          icon: Icons.chevron_right,
          onTap: onNext,
          semanticLabel: 'Next month',
        ),
      ],
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
          color: HomeTokens.track,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Icon(icon, size: 22, color: HomeTokens.textSecondary),
          ),
        ),
      ),
    );
  }
}
