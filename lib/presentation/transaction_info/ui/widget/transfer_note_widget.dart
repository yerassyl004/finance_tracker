import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';

class TransferNoteWidget extends StatelessWidget {
  final TextEditingController controller;
  const TransferNoteWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final text = controller.text.trim();
    final isEmpty = text.isEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(HomeSpacing.md),
      decoration: BoxDecoration(
        color: HomeTokens.background,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        border: Border.all(color: HomeTokens.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.sticky_note_2_outlined,
            size: 18,
            color: HomeTokens.textSecondary,
          ),
          const SizedBox(width: HomeSpacing.sm),
          Expanded(
            child: Text(
              isEmpty ? AppStrings.noNoted : text,
              style: isEmpty ? HomeTokens.bodyMuted() : HomeTokens.body(),
            ),
          ),
        ],
      ),
    );
  }
}
