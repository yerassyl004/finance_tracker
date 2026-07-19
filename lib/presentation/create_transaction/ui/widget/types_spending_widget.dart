import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:flutter/material.dart';

class TypesSpendingWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;

  const TypesSpendingWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = activeColor ?? HomeTokens.accent;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? HomeTokens.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(HomeTokens.radiusSm),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: HomeTokens.body().copyWith(
            color: isSelected ? effectiveColor : HomeTokens.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
            letterSpacing: isSelected ? 0.2 : 0,
          ),
          child: Text(title),
        ),
      ),
    );
  }
}
