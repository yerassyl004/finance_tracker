import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:flutter/material.dart';

class InputTextfieldWidget extends StatelessWidget {
  final String hintText;
  final int maxLine;
  final int minLine;
  final TextInputType inputType;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool isAmount;
  final String? prefix;
  final bool autoFocus;

  const InputTextfieldWidget({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.maxLine,
    required this.minLine,
    required this.controller,
    this.onChanged,
    this.isAmount = false,
    this.prefix,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isAmount) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (prefix != null)
                Text(
                  prefix!,
                  style: HomeTokens.metricHero().copyWith(
                    color: HomeTokens.textTertiary,
                    fontSize: 24,
                  ),
                ),
              IntrinsicWidth(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: inputType,
                  textAlign: TextAlign.center,
                  autofocus: autoFocus,
                  style: HomeTokens.metricHero().copyWith(fontSize: 48),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: HomeTokens.metricHero().copyWith(
                      color: HomeTokens.textTertiary.withValues(alpha: 0.3),
                      fontSize: 48,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: HomeTokens.accent,
                  cursorWidth: 3,
                  cursorRadius: const Radius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: HomeSpacing.xs),
          Text(
            hintText,
            style: HomeTokens.label().copyWith(color: HomeTokens.textTertiary),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: HomeSpacing.md, vertical: HomeSpacing.sm),
      decoration: BoxDecoration(
        color: HomeTokens.surface,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        border: Border.all(color: HomeTokens.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: inputType,
        minLines: minLine,
        maxLines: maxLine,
        style: HomeTokens.body(),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: HomeTokens.body().copyWith(color: HomeTokens.textTertiary),
          border: InputBorder.none,
          isDense: true,
        ),
        cursorColor: HomeTokens.accent,
      ),
    );
  }
}
