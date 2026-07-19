import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:flutter/material.dart';

/// A single summary statistic (Income / Expense) rendered as a calm, bordered
/// tile: a small colour dot + label on top, the amount below. The [color]
/// carries the semantic meaning so the tiles stay otherwise neutral.
class CategoriesWidgets extends StatelessWidget {
  final String category;
  final String cash;
  final Color color;
  const CategoriesWidgets({
    super.key,
    required this.category,
    required this.cash,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HomeSpacing.md,
        vertical: HomeSpacing.sm + HomeSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: HomeTokens.background,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        border: Border.all(color: HomeTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: HomeSpacing.sm),
              Flexible(
                child: Text(
                  category,
                  style: HomeTokens.label(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: HomeSpacing.xs + 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '₸$cash',
              style: HomeTokens.metricMedium().copyWith(color: color),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
