import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';

/// Consistent spacing scale (4 / 8 / 16 / 24 / 32) used across the redesigned
/// Analysis screens. Keeping these in one place gives the layout an even,
/// deliberate rhythm instead of scattered magic numbers.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Minimal, neutral design tokens for the Analysis feature (Linear/Vercel/Notion
/// flavour): one warm accent ([ColorManager.primary]), an almost-white surface,
/// hairline borders and very soft shadows. Centralised so the cards, header and
/// list all read from the same palette rather than ad-hoc literals.
class AnalysisTokens {
  AnalysisTokens._();

  /// Shared corner radius for cards, inputs and the segmented control.
  static const double radiusLg = 20;
  static const double radiusMd = 14;
  static const double radiusPill = 999;

  /// Content is centred and capped on tablet/desktop widths.
  static const double contentMaxWidth = 640;
  static const double wideBreakpoint = 720;

  static const Color background = Color(0xFFF6F6F7);
  static Color get surface => ColorManager.white;
  static Color get accent => ColorManager.primary;
  static Color get accentSoft => ColorManager.primary.withValues(alpha: 0.10);

  static const Color border = Color(0x14000000); // ~8% black hairline
  static const Color track = Color(0xFFECECEE); // segmented-control track

  static const Color textPrimary = Color(0xFF191A1C);
  static const Color textSecondary = Color(0xFF6B6F76);
  static const Color textTertiary = Color(0xFF9BA0A8);

  // Semantic status colours (shared by the AI + budget cards).
  static const Color positive = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static Color get danger => ColorManager.error;

  /// Very soft ambient shadow used on every card.
  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  // Typographic hierarchy — thin wrappers over [AppTextStyle] so callers get a
  // clear heading/body/label vocabulary with the neutral palette baked in.
  static TextStyle heading() =>
      AppTextStyle.bold20().copyWith(color: textPrimary, letterSpacing: -0.4);
  static TextStyle cardTitle() =>
      AppTextStyle.bold16().copyWith(color: textPrimary, letterSpacing: -0.2);
  static TextStyle metricLarge() =>
      AppTextStyle.bold24().copyWith(color: textPrimary, letterSpacing: -0.6);
  static TextStyle body() =>
      AppTextStyle.body14Medium().copyWith(color: textPrimary, height: 1.45);
  static TextStyle bodyMuted() =>
      AppTextStyle.body14Medium().copyWith(color: textSecondary, height: 1.45);
  static TextStyle label() => AppTextStyle.body14Medium().copyWith(
    color: textTertiary,
    fontSize: 12,
    letterSpacing: 0.2,
  );
}

/// A neutral surface card: rounded, hairline-bordered, softly shadowed. The
/// single building block every Analysis section sits inside.
class AnalysisCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AnalysisCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AnalysisTokens.surface,
        borderRadius: BorderRadius.circular(AnalysisTokens.radiusLg),
        border: Border.all(color: AnalysisTokens.border),
        boxShadow: AnalysisTokens.softShadow,
      ),
      child: child,
    );
  }
}

/// Standard card header: an optional accent-tinted icon chip, a title, and an
/// optional trailing action — used by the budget and AI cards for a consistent
/// top line.
class AnalysisCardHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? trailing;

  const AnalysisCardHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AnalysisTokens.accentSoft,
              borderRadius: BorderRadius.circular(AnalysisTokens.radiusMd),
            ),
            child: Icon(icon, size: 18, color: AnalysisTokens.accent),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
        ],
        Expanded(child: Text(title, style: AnalysisTokens.cardTitle())),
        if (trailing != null) trailing!,
      ],
    );
  }
}
