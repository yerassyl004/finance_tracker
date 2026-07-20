import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:flutter/material.dart';

class NameFieldWidget extends StatefulWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? initialValue;
  final String? placeholder;
  const NameFieldWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.placeholder,
  });

  @override
  State<NameFieldWidget> createState() => _NameFieldWidgetState();
}

class _NameFieldWidgetState extends State<NameFieldWidget> {
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
      child: TextField(
        decoration: InputDecoration(
          hintText: widget.placeholder ?? 'Untitled',
          border: InputBorder.none,
          isDense: true,
          hintStyle: HomeTokens.body().copyWith(color: HomeTokens.textTertiary),
        ),
        onChanged: widget.onChanged,
        style: HomeTokens.body(),
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.start,
        cursorColor: HomeTokens.accent,
        controller: controller,
        minLines: 1,
        maxLines: 2,
      ),
    );
  }
}
