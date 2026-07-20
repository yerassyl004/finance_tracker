import 'package:finance_app/domain/models/account.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:flutter/material.dart';

class AccountInfoWidget extends StatelessWidget {
  final Account account;
  const AccountInfoWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HomeSpacing.md),
      decoration: BoxDecoration(
        color: HomeTokens.background,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        border: Border.all(color: HomeTokens.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(HomeSpacing.sm),
            decoration: BoxDecoration(
              color: HomeTokens.surface,
              borderRadius: BorderRadius.circular(HomeTokens.radiusSm),
              border: Border.all(color: HomeTokens.border),
            ),
            child: Image.asset(
              'assets/images/${account.icon}.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.wallet_rounded,
                size: 18,
                color: HomeTokens.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: HomeSpacing.md),
          Expanded(
            child: Text(
              account.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HomeTokens.body().copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
