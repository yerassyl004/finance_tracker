import 'package:finance_app/presentation/accounts_page/ui/widget/pop_up_menu_text.dart';
import 'package:finance_app/domain/models/category.dart';
import 'package:finance_app/presentation/categories_page/bloc/category_bloc.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesWidget extends StatelessWidget {
  final VoidCallback categoryDeleted;
  final Function(Category) categoryEdit;
  final Category category;
  const CategoriesWidget({
    super.key,
    required this.categoryEdit,
    required this.category,
    required this.categoryDeleted,
  });

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        categoryEdit(category);
        break;
      case 1:
        context.read<CategoryBloc>().add(CategoryEvent.deleteAccount(category));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HomeSpacing.sm,
        vertical: HomeSpacing.sm + HomeSpacing.xs,
      ),
      child: Row(
        children: [
          _CategoryIcon(icon: category.icon),
          const SizedBox(width: HomeSpacing.md),
          Expanded(
            child: Text(
              category.title,
              style: HomeTokens.body(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: HomeSpacing.sm),
          _OverflowMenu(onSelected: (item) => onSelected(context, item)),
        ],
      ),
    );
  }
}

/// Rounded, neutral chip holding the category glyph — matches the account /
/// transaction icon treatment so every list reads the same.
class _CategoryIcon extends StatelessWidget {
  final String icon;
  const _CategoryIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(HomeSpacing.sm),
      decoration: BoxDecoration(
        color: HomeTokens.background,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        border: Border.all(color: HomeTokens.border),
      ),
      child: Image.asset('assets/images/$icon.png', fit: BoxFit.contain),
    );
  }
}

/// Low-emphasis overflow (⋯) trigger. Keeps the exact edit/delete actions
/// (0 = edit, 1 = delete) behind a single accessible menu button.
class _OverflowMenu extends StatelessWidget {
  final ValueChanged<int> onSelected;
  const _OverflowMenu({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: HomeTokens.surface,
      elevation: 3,
      shadowColor: Colors.black26,
      tooltip: 'Category options',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        side: const BorderSide(color: HomeTokens.border),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem<int>(
          value: 0,
          child: PopUpMenuText(title: AppStrings.edit),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: PopUpMenuText(title: AppStrings.delete),
        ),
      ],
      icon: const Icon(Icons.more_horiz, color: HomeTokens.textTertiary),
      splashRadius: 24,
      offset: const Offset(0, 48),
    );
  }
}
