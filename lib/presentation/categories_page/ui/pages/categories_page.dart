import 'package:finance_app/app/di.dart';
import 'package:finance_app/domain/models/category.dart';
import 'package:finance_app/presentation/categories_page/bloc/category_bloc.dart';
import 'package:finance_app/presentation/categories_page/di.dart';
import 'package:finance_app/presentation/categories_page/ui/widgets/categories_list.dart';
import 'package:finance_app/presentation/create_category/ui/page/create_category_page.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.getCategoryBloc()..add(CategoryEvent.loadAccounts()),
      child: const CategoriesPageView(),
    );
  }
}

class CategoriesPageView extends StatefulWidget {
  const CategoriesPageView({super.key});

  @override
  State<CategoriesPageView> createState() => _CategoriesPageViewState();
}

class _CategoriesPageViewState extends State<CategoriesPageView> {
  /// Last successfully loaded income/expense lists, kept so a reload (delete /
  /// add / manual refresh) keeps the list on screen with a subtle progress line
  /// instead of blanking to a skeleton on every `loading` emission.
  /// Presentation-only — the BLoC is untouched.
  List<Category>? _lastIncome;
  List<Category>? _lastExpense;

  /// Opens the create/edit category sheet and reloads on a successful save.
  /// Same behaviour as before — only the sheet surface styling changed.
  Future<void> _openCategorySheet(
    BuildContext context, {
    Category? category,
  }) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: HomeSpacing.md,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: HomeTokens.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(HomeTokens.radiusLg),
              ),
            ),
            child: FractionallySizedBox(
              heightFactor: 0.95,
              child: category == null
                  ? CreateCategoryPage()
                  : CreateCategoryPage(
                      args: CreateCategoryPageArguments(category),
                    ),
            ),
          ),
        );
      },
    );

    if (context.mounted && result == true) {
      context.read<CategoryBloc>().add(CategoryEvent.loadAccounts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeTokens.background,
      body: BlocBuilder<CategoryBloc, CategoryState>(
        // Freezed states have value equality, so identical emissions are skipped.
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CategoryLoaded) {
            _lastIncome = state.income;
            _lastExpense = state.expense;
          }
          final income = state.maybeWhen(
            loaded: (income, expense) => income,
            orElse: () => _lastIncome,
          );
          final expense = state.maybeWhen(
            loaded: (income, expense) => expense,
            orElse: () => _lastExpense,
          );
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          final count = (income?.length ?? 0) + (expense?.length ?? 0);

          return SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CategoriesHeader(count: income == null ? null : count),
                    _RefreshBar(visible: isLoading),
                    Expanded(
                      child: _CategoriesBody(
                        state: state,
                        income: income,
                        expense: expense,
                        onRefresh: () {
                          context.read<CategoryBloc>().add(
                            CategoryEvent.loadAccounts(),
                          );
                        },
                        onEdit: (category) =>
                            _openCategorySheet(context, category: category),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: HomeSpacing.md,
                  right: HomeSpacing.md,
                  bottom: HomeSpacing.md,
                  child: _AddCategoryButton(
                    onTap: () => _openCategorySheet(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Left-aligned screen title with an optional muted category count.
class _CategoriesHeader extends StatelessWidget {
  final int? count;
  const _CategoriesHeader({this.count});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            HomeSpacing.md,
            HomeSpacing.md,
            HomeSpacing.md,
            HomeSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.categories, style: HomeTokens.heading()),
              if (count != null) ...[
                const SizedBox(height: HomeSpacing.xs),
                Text(
                  count == 1 ? '1 category' : '$count categories',
                  style: HomeTokens.bodyMuted(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Chooses skeleton / list / empty / error and cross-fades between them. While
/// reloading, the lists are the cached previous values, so the content stays
/// mounted and only updates in place — no skeleton flash on delete or refresh.
class _CategoriesBody extends StatelessWidget {
  final CategoryState state;
  final List<Category>? income;
  final List<Category>? expense;
  final VoidCallback onRefresh;
  final Function(Category) onEdit;

  const _CategoriesBody({
    required this.state,
    required this.income,
    required this.expense,
    required this.onRefresh,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final income = this.income;
    final expense = this.expense;
    final Widget child = state.maybeWhen(
      error: (message) => _CategoriesErrorState(message: message),
      orElse: () {
        if (income == null || expense == null) {
          return const _CategoriesLoadingSkeleton();
        }
        if (income.isEmpty && expense.isEmpty) {
          return const _CategoriesEmptyState();
        }
        return CategoriesList(
          key: const ValueKey('categories'),
          expenseCategories: expense,
          incomeCategories: income,
          pushEditCategory: onEdit,
          updateList: onRefresh,
        );
      },
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}

/// Slim, low-emphasis progress line under the title while a reload is in flight.
class _RefreshBar extends StatelessWidget {
  final bool visible;
  const _RefreshBar({required this.visible});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: LinearProgressIndicator(
          minHeight: 3,
          color: HomeTokens.accent,
          backgroundColor: HomeTokens.track,
        ),
      ),
    );
  }
}

/// Full-width accent action sharing the Home add button's interaction language.
/// Keeps the exact create-category flow via [onTap].
class _AddCategoryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCategoryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: Material(
          color: HomeTokens.accent,
          elevation: 2,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          child: InkWell(
            borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
            onTap: onTap,
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 22, color: HomeTokens.surface),
                  const SizedBox(width: HomeSpacing.sm),
                  Text(
                    AppStrings.addNewCategory,
                    style: HomeTokens.body().copyWith(
                      color: HomeTokens.surface,
                      fontWeight: FontWeight.w700,
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

/// Empty-state placeholder pointing the user at the add action.
class _CategoriesEmptyState extends StatelessWidget {
  const _CategoriesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('empty'),
      child: Padding(
        padding: const EdgeInsets.all(HomeSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: HomeTokens.accentSoft,
                borderRadius: BorderRadius.circular(HomeTokens.radiusLg),
              ),
              child: Icon(
                Icons.category_outlined,
                size: 34,
                color: HomeTokens.accent,
              ),
            ),
            const SizedBox(height: HomeSpacing.lg),
            Text(
              'No categories yet',
              style: HomeTokens.heading(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HomeSpacing.sm),
            Text(
              'Tap “${AppStrings.addNewCategory}” below to create your first one.',
              style: HomeTokens.bodyMuted(),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

/// Calm, surfaced error card (no raw red text dump).
class _CategoriesErrorState extends StatelessWidget {
  final String message;
  const _CategoriesErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(HomeSpacing.lg),
        child: HomeCard(
          padding: const EdgeInsets.all(HomeSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: HomeTokens.danger,
              ),
              const SizedBox(height: HomeSpacing.md),
              Text(
                'Something went wrong',
                style: HomeTokens.metricMedium(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: HomeSpacing.sm),
              Text(
                message,
                style: HomeTokens.bodyMuted(),
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading placeholder mirroring the two-section layout for a stable transition.
class _CategoriesLoadingSkeleton extends StatelessWidget {
  const _CategoriesLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('loading'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: ListView.separated(
          padding: const EdgeInsets.all(HomeSpacing.md),
          itemCount: 2,
          separatorBuilder: (_, __) => const SizedBox(height: HomeSpacing.lg),
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(
                  left: HomeSpacing.xs,
                  bottom: HomeSpacing.sm,
                ),
                child: Skeleton(width: 140, height: 12),
              ),
              HomeCard(
                padding: EdgeInsets.symmetric(
                  vertical: HomeSpacing.md,
                  horizontal: HomeSpacing.md,
                ),
                child: Column(
                  children: [
                    _SkeletonRow(),
                    SizedBox(height: HomeSpacing.md),
                    _SkeletonRow(),
                    SizedBox(height: HomeSpacing.md),
                    _SkeletonRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Skeleton(width: 44, height: 44, radius: HomeTokens.radiusMd),
        SizedBox(width: HomeSpacing.md),
        Expanded(child: Skeleton(width: 120, height: 14)),
        SizedBox(width: HomeSpacing.md),
        Skeleton(width: 24, height: 24),
      ],
    );
  }
}
