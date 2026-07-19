import 'package:finance_app/domain/models/type_spending.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:flutter/material.dart';

class CashTransactionWidget extends StatelessWidget {
  final TypeSpending typeSpending;
  final String cash;
  final double font;
  const CashTransactionWidget({
    super.key,
    required this.typeSpending,
    required this.cash,
    required this.font,
  });

  Color color(TypeSpending typeSpending) => HomeTokens.forType(typeSpending);

  @override
  Widget build(BuildContext context) {
    return Text(
      typeSpending == TypeSpending.expense ? '-₸$cash' : '₸$cash',
      style: TextStyle(
        color: color(typeSpending),
        fontSize: font,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        // Tabular figures keep amounts vertically aligned down the list.
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
