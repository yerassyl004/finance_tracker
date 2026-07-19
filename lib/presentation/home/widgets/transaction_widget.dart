import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/type_spending.dart';
import 'package:finance_app/presentation/home/widgets/cash_transaction_widget.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/transaction_info/ui/page/tansaction_page.dart';
import 'package:flutter/material.dart';

class TransactionWidget extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback updateList;
  const TransactionWidget({
    super.key,
    required this.transaction,
    required this.updateList,
  });

  void _handleTransactionTap(
    BuildContext context,
    Transaction transaction,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          child: TansactionPage(
            args: TansactionInfoArgument(transaction: transaction),
          ),
        );
      },
    );
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    final String? categoryIcon = transaction.category?.icon;
    final String? accountIcon = transaction.account?.icon;
    final String categoryTitle =
        transaction.category?.title ?? AppStrings.transfer;
    final String accountTitle = transaction.account?.title ?? '';
    final String? destinationTitle = transaction.destination?.title;
    final String? destinationIcon = transaction.destination?.icon;
    final String cash = transaction.cash.toString();
    final TypeSpending typeSpending = transaction.typeSpending;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleTransactionTap(context, transaction),
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: HomeSpacing.sm,
            vertical: HomeSpacing.sm + HomeSpacing.xs,
          ),
          child: Row(
            children: [
              _IconChip(asset: categoryIcon ?? 'transfer_icon'),
              const SizedBox(width: HomeSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoryTitle,
                      style: HomeTokens.body(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    _AccountLine(
                      accountIcon: accountIcon,
                      accountTitle: accountTitle,
                      isTransfer: typeSpending == TypeSpending.transfer,
                      destinationIcon: destinationIcon,
                      destinationTitle: destinationTitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: HomeSpacing.sm),
              CashTransactionWidget(
                typeSpending: typeSpending,
                cash: cash,
                font: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded, neutral container holding the category/account glyph — replaces the
/// bare floating icon with a consistent, calm affordance.
class _IconChip extends StatelessWidget {
  final String asset;
  const _IconChip({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(HomeSpacing.sm),
      decoration: BoxDecoration(
        color: HomeTokens.background,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        border: Border.all(color: HomeTokens.border),
      ),
      child: Image.asset('assets/images/$asset.png', fit: BoxFit.contain),
    );
  }
}

/// Muted secondary line: source account, and for transfers a "→ destination".
class _AccountLine extends StatelessWidget {
  final String? accountIcon;
  final String accountTitle;
  final bool isTransfer;
  final String? destinationIcon;
  final String? destinationTitle;

  const _AccountLine({
    required this.accountIcon,
    required this.accountTitle,
    required this.isTransfer,
    required this.destinationIcon,
    required this.destinationTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (accountIcon != null) ...[
          Image.asset('assets/images/$accountIcon.png', width: 16, height: 16),
          const SizedBox(width: HomeSpacing.xs + 2),
        ],
        Flexible(
          child: Text(
            accountTitle,
            style: HomeTokens.bodyMuted(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isTransfer) ...[
          const Icon(
            Icons.arrow_right_alt,
            size: 16,
            color: HomeTokens.textTertiary,
          ),
          if (destinationIcon != null) ...[
            Image.asset(
              'assets/images/$destinationIcon.png',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: HomeSpacing.xs + 2),
          ],
          Flexible(
            child: Text(
              destinationTitle ?? '',
              style: HomeTokens.bodyMuted(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
