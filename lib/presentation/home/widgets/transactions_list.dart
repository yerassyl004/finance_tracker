import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/home/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A day's worth of transactions grouped under one label.
class _DaySection {
  final String label;
  final List<Transaction> transactions;
  const _DaySection(this.label, this.transactions);
}

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final ScrollController scrollController;
  final VoidCallback updateList;

  const TransactionsList({
    super.key,
    required this.transactions,
    required this.scrollController,
    required this.updateList,
  });

  /// Groups consecutive transactions by day, preserving the incoming order.
  /// (Same day-change detection as before — purely presentation grouping.)
  List<_DaySection> _buildSections() {
    final sections = <_DaySection>[];
    String? lastDate;
    for (final transaction in transactions) {
      final label =
          '${DateFormat('MMMM d').format(transaction.date)}, '
          '${DateFormat('EEEE').format(transaction.date)}';
      if (label != lastDate) {
        lastDate = label;
        sections.add(_DaySection(label, []));
      }
      sections.last.transactions.add(transaction);
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final sections = _buildSections();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(
            HomeSpacing.md,
            HomeSpacing.md,
            HomeSpacing.md,
            // Leave room so the last card clears the floating action button.
            96,
          ),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : HomeSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: HomeSpacing.xs,
                      bottom: HomeSpacing.sm,
                    ),
                    child: Text(
                      section.label.toUpperCase(),
                      style: HomeTokens.label(),
                    ),
                  ),
                  HomeCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: HomeSpacing.xs,
                      horizontal: HomeSpacing.sm,
                    ),
                    child: Column(
                      children: [
                        for (
                          var i = 0;
                          i < section.transactions.length;
                          i++
                        ) ...[
                          if (i > 0)
                            const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 52,
                              color: HomeTokens.border,
                            ),
                          TransactionWidget(
                            transaction: section.transactions[i],
                            updateList: updateList,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
