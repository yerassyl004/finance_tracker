import 'package:finance_app/presentation/accounts_page/ui/widget/account_widget.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/domain/models/account.dart';
import 'package:flutter/material.dart';

class AccountsList extends StatelessWidget {
  final VoidCallback updateList;
  final Function(Account) pushEditAccount;
  final Function(Account) deleteAccount;
  final List<Account> accounts;
  const AccountsList({
    super.key,
    required this.accounts,
    required this.updateList,
    required this.pushEditAccount,
    required this.deleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            HomeSpacing.md,
            HomeSpacing.md,
            HomeSpacing.md,
            // Clearance so the last tile never sits under the add button.
            96,
          ),
          itemCount: accounts.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: HomeSpacing.sm + HomeSpacing.xs),
          itemBuilder: (context, index) {
            return AccountWidget(
              account: accounts[index],
              accountDelete: deleteAccount,
              accountEdit: pushEditAccount,
            );
          },
        ),
      ),
    );
  }
}
