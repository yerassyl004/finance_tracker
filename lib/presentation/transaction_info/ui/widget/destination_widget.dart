import 'package:finance_app/domain/models/account.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/transaction_info/ui/widget/account_info_widget.dart';
import 'package:flutter/material.dart';

class DestinationWidget extends StatelessWidget {
  final Account? destination;
  const DestinationWidget({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    if (destination == null) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: HomeSpacing.sm),
        Icon(
          Icons.arrow_downward_rounded,
          size: 18,
          color: HomeTokens.textTertiary,
        ),
        const SizedBox(height: HomeSpacing.sm),
        AccountInfoWidget(account: destination!),
      ],
    );
  }
}
