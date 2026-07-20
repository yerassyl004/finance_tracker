import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/app_router.dart';
import 'package:finance_app/presentation/create_transaction/ui/pages/new_create_transactions_page.dart';
import 'package:finance_app/presentation/home/widgets/cash_transaction_widget.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/type_spending.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderDetailWidget extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;
  const HeaderDetailWidget({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  void _confirmDelete(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(AppStrings.confirmDelete),
            content: Text(AppStrings.deleteSubTitle),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppStrings.cancel),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  onDelete();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                child: Text(AppStrings.delete),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: HomeTokens.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(HomeTokens.radiusLg),
            ),
            title: Text(AppStrings.confirmDelete, style: HomeTokens.heading()),
            content: Text(
              AppStrings.deleteSubTitle,
              style: HomeTokens.bodyMuted(),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  AppStrings.cancel,
                  style: HomeTokens.body().copyWith(
                    color: HomeTokens.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  onDelete();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  AppStrings.delete,
                  style: HomeTokens.body().copyWith(
                    color: HomeTokens.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _edit(BuildContext context) async {
    final result = await context.pushRoute(
      NewCreateTransactionsRoute(args: CreateTransactionsArgument(transaction)),
    );
    if (context.mounted && result == true) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTransfer = transaction.typeSpending == TypeSpending.transfer;
    final String? icon = isTransfer
        ? 'transfer_icon'
        : transaction.category?.icon;
    final String title = isTransfer
        ? AppStrings.transfer
        : (transaction.category?.title ?? '');
    final String date = DateFormat(
      'dd MMM yyyy · HH:mm',
    ).format(transaction.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(HomeSpacing.sm),
              decoration: BoxDecoration(
                color: HomeTokens.background,
                borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
                border: Border.all(color: HomeTokens.border),
              ),
              child: icon != null
                  ? Image.asset(
                      'assets/images/$icon.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.receipt_long_outlined,
                        size: 20,
                        color: HomeTokens.textSecondary,
                      ),
                    )
                  : Icon(
                      Icons.receipt_long_outlined,
                      size: 20,
                      color: HomeTokens.textSecondary,
                    ),
            ),
            const SizedBox(width: HomeSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: HomeTokens.heading(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(date, style: HomeTokens.bodyMuted()),
                ],
              ),
            ),
            _ActionButton(
              icon: Icons.edit_outlined,
              onTap: () => _edit(context),
            ),
            const SizedBox(width: HomeSpacing.sm),
            _ActionButton(
              icon: Icons.delete_outline_rounded,
              danger: true,
              onTap: () => _confirmDelete(context),
            ),
          ],
        ),
        const SizedBox(height: HomeSpacing.lg),
        Center(
          child: CashTransactionWidget(
            typeSpending: transaction.typeSpending,
            cash: transaction.cash.toString(),
            font: 34,
          ),
        ),
      ],
    );
  }
}

/// Ghost circular icon button used for the edit / delete actions.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? HomeTokens.danger : HomeTokens.textSecondary;
    return Material(
      color: HomeTokens.background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
