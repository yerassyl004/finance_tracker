import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:flutter/material.dart';

class PopUpMenuText extends StatelessWidget {
  final String title;
  const PopUpMenuText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // "Delete" reads in the danger colour; everything else stays neutral ink.
    final isDestructive = title.toLowerCase() == 'delete';
    return Text(
      title,
      style: HomeTokens.body().copyWith(
        fontSize: 15,
        color: isDestructive ? HomeTokens.danger : HomeTokens.textPrimary,
      ),
    );
  }
}
