import 'package:finance_app/app/di.dart';
import 'package:finance_app/domain/models/category.dart';
import 'package:finance_app/presentation/create_account/ui/widget/name_field_widget.dart';
import 'package:finance_app/presentation/create_category/bloc/create_category_bloc.dart';
import 'package:finance_app/presentation/create_category/di.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCategoryPageArguments {
  final Category? category;
  CreateCategoryPageArguments(this.category);
}

class CreateCategoryPage extends StatelessWidget {
  final CreateCategoryPageArguments? args;
  const CreateCategoryPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getCreateCategoryBloc(args?.category),
      child: CreateCategoryPageView(isEdit: args?.category != null),
    );
  }
}

class CreateCategoryPageView extends StatelessWidget {
  final bool isEdit;
  const CreateCategoryPageView({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCategoryBloc, CreateCategoryState>(
      listener: (context, state) {
        if (state is SuccessCreateCategoryState) {
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        show: (data) {
          final bloc = context.read<CreateCategoryBloc>();
          final canSave = (data.category?.title ?? '').trim().isNotEmpty;

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  HomeSpacing.md,
                  HomeSpacing.sm,
                  HomeSpacing.md,
                  HomeSpacing.md + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _GrabHandle(),
                    _SheetHeader(
                      title: isEdit
                          ? 'Edit category'
                          : AppStrings.addNewCategory,
                    ),
                    const SizedBox(height: HomeSpacing.lg),

                    _FieldLabel(AppStrings.type),
                    const SizedBox(height: HomeSpacing.sm),
                    _CategoryTypeSelector(
                      selected: data.categoryType,
                      onChanged: (type) => bloc.add(
                        CreateCategoryEvent.edit(
                          data: data.copyWith(categoryType: type),
                        ),
                      ),
                    ),
                    const SizedBox(height: HomeSpacing.md),

                    _FieldLabel(AppStrings.name),
                    const SizedBox(height: HomeSpacing.sm),
                    NameFieldWidget(
                      initialValue: data.category?.title,
                      placeholder: 'e.g. Groceries, Salary',
                      onChanged: (text) => bloc.add(
                        CreateCategoryEvent.edit(
                          data: data.copyWith(
                            category: data.category?.copyWith(title: text),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: HomeSpacing.md),

                    _FieldLabel(AppStrings.selectIcon),
                    const SizedBox(height: HomeSpacing.sm),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.imageAssets.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: HomeSpacing.sm,
                            mainAxisSpacing: HomeSpacing.sm,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) => _IconOption(
                        asset: data.imageAssets[index],
                        selected: data.selectedImageIndex == index,
                        onTap: () => bloc.add(
                          CreateCategoryEvent.edit(
                            data: data.copyWith(selectedImageIndex: index),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: HomeSpacing.xl),

                    PrimaryButton(
                      label: isEdit ? AppStrings.save : AppStrings.add,
                      enabled: canSave,
                      onTap: () =>
                          bloc.add(CreateCategoryEvent.create(data: data)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// Pieces
// =============================================================================

/// Segmented Expense · Income control, colour-tinted per type when selected.
class _CategoryTypeSelector extends StatelessWidget {
  final CategoryType selected;
  final ValueChanged<CategoryType> onChanged;

  const _CategoryTypeSelector({
    required this.selected,
    required this.onChanged,
  });

  static const _items = <CategoryType, String>{
    CategoryType.expense: AppStrings.expenseText,
    CategoryType.income: AppStrings.incomeText,
  };

  Color _tint(CategoryType type) =>
      type == CategoryType.income ? HomeTokens.positive : HomeTokens.accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HomeSpacing.xs),
      decoration: BoxDecoration(
        color: HomeTokens.track,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
      ),
      child: Row(
        children: _items.entries.map((e) {
          final isSelected = e.key == selected;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? HomeTokens.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(HomeTokens.radiusSm),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  e.value,
                  style: HomeTokens.body().copyWith(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? _tint(e.key) : HomeTokens.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GrabHandle extends StatelessWidget {
  const _GrabHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: HomeSpacing.md),
        decoration: BoxDecoration(
          color: HomeTokens.track,
          borderRadius: BorderRadius.circular(HomeTokens.radiusPill),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;
  const _SheetHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: HomeTokens.heading())),
        SizedBox(
          width: 36,
          height: 36,
          child: Material(
            color: HomeTokens.track,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: HomeTokens.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: HomeTokens.label());
  }
}

class _IconOption extends StatelessWidget {
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  const _IconOption({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(HomeSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? HomeTokens.accentSoft : HomeTokens.background,
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          border: Border.all(
            color: selected ? HomeTokens.accent : HomeTokens.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Image.asset('assets/images/$asset.png', fit: BoxFit.contain),
      ),
    );
  }
}
