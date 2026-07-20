import 'package:finance_app/domain/models/type_spending.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';

/// App-wide design tokens (formerly `home/widgets/home_theme.dart`). Promoted
/// to the shared `resourses/` layer so every feature — Home, Accounts, … —
/// reads from one palette/spacing/component vocabulary and the product feels
/// like a single system. Class names keep the `Home*` prefix for source
/// stability across the existing importers.
///
/// Consistent spacing scale: 4 / 8 / 16 / 24 / 32.
class HomeSpacing {
  HomeSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Minimal, neutral tokens (Linear/Vercel/Notion flavour): one warm accent
/// ([ColorManager.primary]), an almost-white surface, hairline borders and very
/// soft shadows.
class HomeTokens {
  HomeTokens._();

  /// Shared corner radius for cards, list tiles, chips and buttons.
  static const double radiusLg = 20;
  static const double radiusMd = 14;
  static const double radiusSm = 10;
  static const double radiusPill = 999;

  /// Content is centred and capped on tablet/desktop widths.
  static const double contentMaxWidth = 640;
  static const double wideBreakpoint = 720;

  static const Color background = Color(0xFFF6F6F7);
  static Color get surface => ColorManager.white;
  static Color get accent => ColorManager.primary;
  static Color get accentSoft => ColorManager.primary.withValues(alpha: 0.10);

  static const Color border = Color(0x14000000); // ~8% black hairline
  static const Color track = Color(0xFFECECEE);

  static const Color textPrimary = Color(0xFF191A1C);
  static const Color textSecondary = Color(0xFF6B6F76);
  static const Color textTertiary = Color(0xFF9BA0A8);

  // Semantic status colours.
  static const Color positive = Color(0xFF16A34A); // income
  static Color get danger => ColorManager.error;

  /// Semantic colour for a transaction amount. Expense uses the warm brand
  /// accent, income the positive green and transfers a calm neutral — an
  /// "accent + neutral" reading that keeps the list from feeling loud.
  static Color forType(TypeSpending type) {
    switch (type) {
      case TypeSpending.expense:
        return accent;
      case TypeSpending.income:
        return positive;
      case TypeSpending.transfer:
        return textSecondary;
    }
  }

  /// Very soft ambient shadow used on every card.
  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  // Typographic hierarchy — thin wrappers over [AppTextStyle] giving callers a
  // clear heading / metric / body / label vocabulary with the palette baked in.
  static TextStyle heading() =>
      AppTextStyle.bold20().copyWith(color: textPrimary, letterSpacing: -0.4);
  static TextStyle metricHero() =>
      AppTextStyle.bold30().copyWith(color: textPrimary, letterSpacing: -0.8);
  static TextStyle metricMedium() =>
      AppTextStyle.bold16().copyWith(color: textPrimary, letterSpacing: -0.2);
  static TextStyle body() =>
      AppTextStyle.body16Medium().copyWith(color: textPrimary);
  static TextStyle bodyMuted() =>
      AppTextStyle.body14Medium().copyWith(color: textSecondary);
  static TextStyle label() => AppTextStyle.body14Medium().copyWith(
    color: textTertiary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
}

/// A neutral surface card: rounded, hairline-bordered, softly shadowed — the
/// single building block every screen's sections sit inside.
class HomeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const HomeCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(HomeSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: HomeTokens.surface,
        borderRadius: BorderRadius.circular(HomeTokens.radiusLg),
        border: Border.all(color: HomeTokens.border),
        boxShadow: HomeTokens.softShadow,
      ),
      child: child,
    );
  }
}

/// Full-width accent primary action with disabled + loading states — the single
/// call-to-action button shared across the create / edit forms and add actions.
class PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool loading;
  final IconData? icon;
  final VoidCallback onTap;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final active = enabled && !loading;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: active ? 1 : 0.55,
      child: Material(
        color: active ? HomeTokens.accent : HomeTokens.textTertiary,
        elevation: active ? 2 : 0,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          onTap: active ? onTap : null,
          child: SizedBox(
            height: 54,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 20, color: HomeTokens.surface),
                          const SizedBox(width: HomeSpacing.sm),
                        ],
                        Text(
                          label,
                          style: HomeTokens.body().copyWith(
                            color: HomeTokens.surface,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single shimmering placeholder block. Uses a lightweight looping
/// [AnimationController] — no external `shimmer` package needed.
class Skeleton extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const Skeleton({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = HomeTokens.radiusSm,
  });

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = 0.35 + (_controller.value * 0.35);
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: HomeTokens.track.withValues(alpha: t),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}
