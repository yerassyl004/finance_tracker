/// Actual spend versus the user's budget ("max") for a single expense category
/// in the current month.
///
/// Drives the per-category budget list on the Analysis page and is fed to the
/// AI so it can analyse and warn on each category. Pure domain (no Flutter).
class CategoryBudgetProgress {
  /// Persisted category id — the key used in [FinancialProfile.categoryBudgets].
  final String categoryId;
  final String title;
  final String icon;

  /// Amount spent in this category this month.
  final double spent;

  /// The user's monthly budget for this category; 0 when none is set.
  final double max;

  const CategoryBudgetProgress({
    required this.categoryId,
    required this.title,
    required this.icon,
    required this.spent,
    required this.max,
  });

  bool get hasBudget => max > 0;

  bool get isOverBudget => hasBudget && spent > max;

  /// Fraction of the budget used (0..∞); 0 when no budget is set.
  double get ratio => hasBudget ? spent / max : 0;

  CategoryBudgetProgress copyWith({double? max}) => CategoryBudgetProgress(
    categoryId: categoryId,
    title: title,
    icon: icon,
    spent: spent,
    max: max ?? this.max,
  );
}
