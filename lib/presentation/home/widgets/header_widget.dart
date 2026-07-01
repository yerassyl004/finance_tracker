import 'package:finance_app/app/extensions.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/presentation/home/widgets/categories_widgets.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
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
  Size get preferredSize => Size.fromHeight(170.h);

  @override
  Widget build(BuildContext context) {
    final categoryWidth = (MediaQuery.of(context).size.width - 16) / 3;
    final total = incomeAmount - expenseAmount;
    final monthYear = DateFormat('MMMM, yyyy').format(currentDate);
    final topPadding = MediaQuery.of(context).padding.top;

    return PreferredSize(
      preferredSize: preferredSize,
      child: Material(
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox(
            height: preferredSize.height - topPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _previousMonth,
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    SizedBox(
                      width: 170.h,
                      child: Text(
                        monthYear,
                        style: AppTextStyle.body16Medium(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: _nextMonth,
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
                8.ph,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: categoryWidth,
                        child: CategoriesWidgets(
                          category: AppStrings.expenseText,
                          cash: expenseAmount.toStringAsFixed(2),
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(
                        width: categoryWidth,
                        child: CategoriesWidgets(
                          category: AppStrings.incomeText,
                          cash: incomeAmount.toStringAsFixed(2),
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: categoryWidth,
                        child: CategoriesWidgets(
                          category: AppStrings.balanceText,
                          cash: total.toStringAsFixed(2),
                          color: total > 0 ? Colors.blue : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
