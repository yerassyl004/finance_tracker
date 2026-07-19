import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/app_router.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/analysis_theme.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:finance_app/presentation/transaction_category_list/ui/page/transactions_category.dart';
import 'package:finance_app/domain/models/analysis.dart';
import 'package:flutter/material.dart';

class TransactionAnalysWidget extends StatelessWidget {
  final Analysis analysis;
  final DateTime dateTime;

  const TransactionAnalysWidget({
    super.key,
    required this.analysis,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final categoryIcon = analysis.category.icon;
    final categoryTitle = analysis.category.title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AnalysisTokens.radiusMd),
        onTap: () async {
          final result = await context.pushRoute(
            TransactionsCategoryRoute(
              args: TransactionsCategoryArguments(
                analysis.category,
                dateTime,
                analysis.cash,
              ),
            ),
          );
          if (context.mounted && result == true) {
            context.maybePop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AnalysisTokens.surface,
                  borderRadius: BorderRadius.circular(AnalysisTokens.radiusMd),
                  border: Border.all(color: AnalysisTokens.border),
                ),
                child: Image.asset(
                  'assets/images/$categoryIcon.png',
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.category_outlined,
                    size: 18,
                    color: AnalysisTokens.accent,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 4),
              Expanded(
                child: Text(
                  categoryTitle,
                  style: AnalysisTokens.body().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '₸${analysis.cash.toStringAsFixed(2)}',
                style: AppTextStyle.bold14().copyWith(
                  color: AnalysisTokens.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
