import 'package:finance_app/presentation/categories_page/ui/widgets/categories_widget.dart';
import 'package:finance_app/domain/models/category.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  final VoidCallback updateList;
  final Function(Category) pushEditCategory;
  final List<Category> expenseCategories;
  final List<Category> incomeCategories;

  const CategoriesList({
    super.key,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.pushEditCategory,
    required this.updateList,
  });

  @override
  Widget build(BuildContext context) {
    // Only render a section that actually has categories; the all-empty case is
    // handled one level up by the page's empty state.
    final sections = <Widget>[
      if (expenseCategories.isNotEmpty)
        _CategorySection(
          title: AppStrings.expenseCategories,
          categories: expenseCategories,
          pushEditCategory: pushEditCategory,
          updateList: updateList,
        ),
      if (incomeCategories.isNotEmpty)
        _CategorySection(
          title: AppStrings.incomeCategories,
          categories: incomeCategories,
          pushEditCategory: pushEditCategory,
          updateList: updateList,
        ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            HomeSpacing.md,
            HomeSpacing.md,
            HomeSpacing.md,
            // Clearance so the last card never sits under the add button.
            96,
          ),
          itemCount: sections.length,
          separatorBuilder: (_, __) => const SizedBox(height: HomeSpacing.lg),
          itemBuilder: (context, index) => sections[index],
        ),
      ),
    );
  }
}

/// A labelled group (Expense / Income) rendered as one soft card of rows.
class _CategorySection extends StatelessWidget {
  final String title;
  final List<Category> categories;
  final Function(Category) pushEditCategory;
  final VoidCallback updateList;

  const _CategorySection({
    required this.title,
    required this.categories,
    required this.pushEditCategory,
    required this.updateList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: HomeSpacing.xs,
            bottom: HomeSpacing.sm,
          ),
          child: Text(title.toUpperCase(), style: HomeTokens.label()),
        ),
        HomeCard(
          padding: const EdgeInsets.symmetric(
            vertical: HomeSpacing.xs,
            horizontal: HomeSpacing.sm,
          ),
          child: Column(
            children: [
              for (var i = 0; i < categories.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 52,
                    color: HomeTokens.border,
                  ),
                CategoriesWidget(
                  category: categories[i],
                  categoryDeleted: updateList,
                  categoryEdit: pushEditCategory,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
