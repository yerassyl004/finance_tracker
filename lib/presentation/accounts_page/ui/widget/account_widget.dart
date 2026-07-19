import 'package:finance_app/presentation/accounts_page/ui/widget/pop_up_menu_text.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/domain/models/account.dart';

class AccountWidget extends StatelessWidget {
  final Account account;
  final Function(Account) accountDelete;
  final Function(Account) accountEdit;
  const AccountWidget({
    super.key,
    required this.account,
    required this.accountDelete,
    required this.accountEdit,
  });

  /// Balance colour with a calm "accent + neutral" reading (no loud greens):
  /// positive balances sit in neutral ink, a zero balance is muted, and a
  /// negative balance is flagged with the warm accent — attention, not alarm.
  Color getColor() {
    if (account.cash < 0) {
      return HomeTokens.accent;
    } else if (account.cash == 0) {
      return HomeTokens.textTertiary;
    } else {
      return HomeTokens.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      padding: const EdgeInsets.symmetric(
        horizontal: HomeSpacing.md,
        vertical: HomeSpacing.sm + HomeSpacing.xs,
      ),
      child: Row(
        children: [
          _AccountIcon(icon: account.icon),
          const SizedBox(width: HomeSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  account.title,
                  style: HomeTokens.metricMedium(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(AppStrings.balanceText, style: HomeTokens.label()),
              ],
            ),
          ),
          const SizedBox(width: HomeSpacing.sm),
          Text(
            '₸${account.cash.toStringAsFixed(2)}',
            style: HomeTokens.metricMedium().copyWith(color: getColor()),
          ),
          const SizedBox(width: HomeSpacing.xs),
          _OverflowMenu(onSelected: (item) => onSelected(context, item)),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        accountEdit(account);
        break;
      case 1:
        accountDelete(account);
        break;
    }
  }
}

/// Rounded, neutral chip holding the account glyph — mirrors the transaction
/// row's icon treatment so both screens share one visual language.
class _AccountIcon extends StatelessWidget {
  final String icon;
  const _AccountIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(HomeSpacing.sm),
      decoration: BoxDecoration(
        color: HomeTokens.background,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        border: Border.all(color: HomeTokens.border),
      ),
      child: Image.asset('assets/images/$icon.png', fit: BoxFit.contain),
    );
  }
}

/// Low-emphasis overflow (⋯) trigger. Keeps the exact edit/delete actions
/// (0 = edit, 1 = delete) but drops the old transparent-icon Stack hack for a
/// single, accessible ≥48px menu button.
class _OverflowMenu extends StatelessWidget {
  final ValueChanged<int> onSelected;
  const _OverflowMenu({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: HomeTokens.surface,
      elevation: 3,
      shadowColor: Colors.black26,
      tooltip: 'Account options',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        side: const BorderSide(color: HomeTokens.border),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem<int>(
          value: 0,
          child: PopUpMenuText(title: AppStrings.edit),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: PopUpMenuText(title: AppStrings.delete),
        ),
      ],
      icon: const Icon(Icons.more_horiz, color: HomeTokens.textTertiary),
      splashRadius: 24,
      offset: const Offset(0, 48),
    );
  }
}
