import 'dart:convert';

/// The user's primary reason for using the app, captured during onboarding.
///
/// Drives tailored guidance and is a key cohort dimension for analysis.
enum FinancialGoal {
  saveMore,
  payOffDebt,
  trackSpending,
  budgetBetter,
  understandMoney;

  /// Human-readable label shown in the survey.
  String get label {
    switch (this) {
      case FinancialGoal.saveMore:
        return 'Save more';
      case FinancialGoal.payOffDebt:
        return 'Pay off debt';
      case FinancialGoal.trackSpending:
        return 'Track spending';
      case FinancialGoal.budgetBetter:
        return 'Budget better';
      case FinancialGoal.understandMoney:
        return 'Understand my money';
    }
  }

  static FinancialGoal? fromName(String? name) {
    for (final goal in FinancialGoal.values) {
      if (goal.name == name) return goal;
    }
    return null;
  }
}

/// How often the user is paid. Meta-information for interpreting income.
enum PayFrequency {
  monthly,
  biweekly,
  weekly;

  String get label {
    switch (this) {
      case PayFrequency.monthly:
        return 'Monthly';
      case PayFrequency.biweekly:
        return 'Bi-weekly';
      case PayFrequency.weekly:
        return 'Weekly';
    }
  }

  static PayFrequency fromName(String? name) {
    for (final freq in PayFrequency.values) {
      if (freq.name == name) return freq;
    }
    return PayFrequency.monthly;
  }
}

/// A one-time financial profile captured during onboarding.
///
/// Persisted as a single row (see [FinancialProfileDao]). Existence of a
/// profile is what marks onboarding as completed.
class FinancialProfile {
  /// Single-row table, so the id is a fixed constant.
  static const String primaryId = 'primary';

  final String id;

  /// The user's primary financial goal. Null only for legacy profiles saved
  /// before this field existed.
  FinancialGoal? goal;

  /// ISO 4217 currency code (e.g. 'USD') the user tracks money in.
  String currencyCode;

  /// How often the user is paid.
  PayFrequency payFrequency;

  double salary;
  double otherIncome;
  double housePayment;
  double carPayment;
  double utilitiesPayment;

  /// Monthly budget target ("max") per expense category, keyed by category id.
  Map<String, double> categoryBudgets;

  FinancialProfile({
    this.id = primaryId,
    this.goal,
    this.currencyCode = 'USD',
    this.payFrequency = PayFrequency.monthly,
    required this.salary,
    required this.otherIncome,
    required this.housePayment,
    required this.carPayment,
    required this.utilitiesPayment,
    Map<String, double>? categoryBudgets,
  }) : categoryBudgets = categoryBudgets ?? {};

  /// Total monthly income (salary + other income).
  double get totalIncome => salary + otherIncome;

  /// Total of the fixed monthly obligations captured in the survey.
  double get fixedExpenses => housePayment + carPayment + utilitiesPayment;

  /// Sum of every per-category budget target.
  double get totalBudget =>
      categoryBudgets.values.fold(0.0, (sum, value) => sum + value);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal': goal?.name,
      'currencyCode': currencyCode,
      'payFrequency': payFrequency.name,
      'salary': salary,
      'otherIncome': otherIncome,
      'housePayment': housePayment,
      'carPayment': carPayment,
      'utilitiesPayment': utilitiesPayment,
      'categoryBudgets': jsonEncode(categoryBudgets),
    };
  }

  factory FinancialProfile.fromJson(Map<String, dynamic> json) {
    final rawBudgets = json['categoryBudgets'];
    final decoded = rawBudgets != null
        ? (jsonDecode(rawBudgets) as Map<String, dynamic>)
        : <String, dynamic>{};
    return FinancialProfile(
      id: json['id'],
      goal: FinancialGoal.fromName(json['goal'] as String?),
      currencyCode: (json['currencyCode'] as String?) ?? 'USD',
      payFrequency: PayFrequency.fromName(json['payFrequency'] as String?),
      salary: (json['salary'] as num).toDouble(),
      otherIncome: (json['otherIncome'] as num).toDouble(),
      housePayment: (json['housePayment'] as num).toDouble(),
      carPayment: (json['carPayment'] as num).toDouble(),
      utilitiesPayment: (json['utilitiesPayment'] as num).toDouble(),
      categoryBudgets: decoded.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }

  FinancialProfile copyWith({
    FinancialGoal? goal,
    String? currencyCode,
    PayFrequency? payFrequency,
    double? salary,
    double? otherIncome,
    double? housePayment,
    double? carPayment,
    double? utilitiesPayment,
    Map<String, double>? categoryBudgets,
  }) {
    return FinancialProfile(
      id: id,
      goal: goal ?? this.goal,
      currencyCode: currencyCode ?? this.currencyCode,
      payFrequency: payFrequency ?? this.payFrequency,
      salary: salary ?? this.salary,
      otherIncome: otherIncome ?? this.otherIncome,
      housePayment: housePayment ?? this.housePayment,
      carPayment: carPayment ?? this.carPayment,
      utilitiesPayment: utilitiesPayment ?? this.utilitiesPayment,
      categoryBudgets: categoryBudgets ?? this.categoryBudgets,
    );
  }
}
