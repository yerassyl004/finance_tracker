import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BalanceFieldWidget extends StatefulWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? initialValue;
  const BalanceFieldWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<BalanceFieldWidget> createState() => _BalanceFieldWidgetState();
}

class _BalanceFieldWidgetState extends State<BalanceFieldWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HomeSpacing.md,
        vertical: HomeSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        color: HomeTokens.background,
        border: Border.all(color: HomeTokens.border),
      ),
      child: Row(
        children: [
          Text(
            '₸',
            style: HomeTokens.body().copyWith(color: HomeTokens.textSecondary),
          ),
          const SizedBox(width: HomeSpacing.sm),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '0.00',
                border: InputBorder.none,
                isDense: true,
                hintStyle: HomeTokens.body().copyWith(
                  color: HomeTokens.textTertiary,
                ),
              ),
              style: HomeTokens.body(),
              onChanged: widget.onChanged,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              cursorColor: HomeTokens.accent,
              controller: controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\₸?[\d,]*\.?\d{0,2}'),
                ),
              ],
              minLines: 1,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
