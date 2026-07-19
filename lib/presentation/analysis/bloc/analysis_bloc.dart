import 'package:bloc/bloc.dart';
import 'package:finance_app/domain/models/analysis.dart';
import 'package:finance_app/domain/models/category.dart';
import 'package:finance_app/domain/models/category_budget_progress.dart';
import 'package:finance_app/domain/models/financial_analysis.dart';
import 'package:finance_app/domain/usecases.dart/category/load_category_usecase.dart';
import 'package:finance_app/domain/usecases.dart/transactions/expence_count_usecase.dart';
import 'package:finance_app/domain/usecases.dart/transactions/income_count_usecase.dart';
import 'package:finance_app/domain/usecases.dart/analysis/load_analysis_usecase.dart';
import 'package:finance_app/domain/usecases.dart/analysis/get_financial_analysis_usecase.dart';
import 'package:finance_app/domain/usecases.dart/transactions/load_transactions_by_type_usecase.dart';
import 'package:finance_app/domain/usecases.dart/analysis/segment_persentage_usecase.dart';
import 'package:finance_app/domain/usecases.dart/financial_profile/load_financial_profile_usecase.dart';
import 'package:finance_app/domain/usecases.dart/financial_profile/save_financial_profile_usecase.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finance_app/domain/models/type_spending.dart';
import 'package:finance_app/domain/models/segment.dart';
import 'package:finance_app/domain/models/transaction.dart';

part 'analysis_bloc.freezed.dart';

@freezed
class AnalysisData with _$AnalysisData {
  const factory AnalysisData({
    required DateTime currentMonth,
    required List<Transaction> transactions,
    required List<Segment> segments,
    @Default([]) List<Analysis> analysis,
    @Default(0) double expenseAmount,
    @Default(0) double incomeAmount,
    @Default(TypeSpending.expense) TypeSpending selectedType,
    String? errorMessage,
    // AI insights (Gemini). Kept on the loaded data so the rest of the screen
    // stays visible while insights load or fail.
    @Default(false) bool aiLoading,
    FinancialAnalysis? aiAnalysis,
    String? aiError,
    // Per-category budget ("max") vs. actual spend this month, over-budget
    // first. Drives the category budgets card and feeds the AI.
    @Default([]) List<CategoryBudgetProgress> categoryBudgets,
  }) = _AnalysisData;
}

@freezed
class AnalysisEvent with _$AnalysisEvent {
  const factory AnalysisEvent.loadTransactions() = LoadTransactions;

  const factory AnalysisEvent.updateTransactions({
    required DateTime month,
    required TypeSpending typeSpending,
  }) = UpdateTransactions;

  /// Resolves AI insights for the currently loaded period. With
  /// [forceRefresh] false it reuses the cached result when the inputs are
  /// unchanged (no Gemini call); true forces a fresh analysis.
  const factory AnalysisEvent.loadAiInsights({
    @Default(false) bool forceRefresh,
  }) = LoadAiInsights;

  /// Persists a new monthly budget ("max") for a single category.
  const factory AnalysisEvent.updateCategoryBudget(
    String categoryId,
    double value,
  ) = UpdateCategoryBudget;
}

@freezed
class AnalysisState with _$AnalysisState {
  const factory AnalysisState.initial() = AnalysisInitial;
  const factory AnalysisState.loading({required AnalysisData data}) =
      AnalysisLoading;
  const factory AnalysisState.loaded({required AnalysisData data}) =
      AnalysisLoaded;
  const factory AnalysisState.error(String message) = AnalysisError;
}

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final ExpenceCountUsecase getExpenseAmountUseCase;
  final IncomeCountUsecase getIncomeAmountUseCase;
  final SegmentPersentageUsecase segmentPersentageUsecase;
  final LoadAnalysisUsecase loadAnalysisUsecase;
  final LoadTransactionsByTypeUsecase loadTransactionsWithTypeUsecase;
  final LoadFinancialProfileUsecase loadFinancialProfileUsecase;
  final GetFinancialAnalysisUseCase getFinancialAnalysisUseCase;
  final SaveFinancialProfileUsecase saveFinancialProfileUsecase;
  final LoadCategoryUsecase loadCategoryUsecase;

  AnalysisBloc(
    this.getExpenseAmountUseCase,
    this.getIncomeAmountUseCase,
    this.segmentPersentageUsecase,
    this.loadAnalysisUsecase,
    this.loadTransactionsWithTypeUsecase,
    this.loadFinancialProfileUsecase,
    this.getFinancialAnalysisUseCase,
    this.saveFinancialProfileUsecase,
    this.loadCategoryUsecase,
  ) : super(const AnalysisState.initial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<UpdateTransactions>(_onUpdateTransactions);
    on<LoadAiInsights>(_onLoadAiInsights);
    on<UpdateCategoryBudget>(_onUpdateCategoryBudget);

    add(AnalysisEvent.loadTransactions());
  }

  /// Builds the per-category budget-vs-spend rows for [month], independent of
  /// the selected view type (always uses the month's expense transactions), so
  /// the budget card is correct even while viewing income. Categories with a
  /// budget but no spend are included via the category list.
  Future<List<CategoryBudgetProgress>> _loadCategoryBudgets(
    DateTime month,
  ) async {
    final profileResult = await loadFinancialProfileUsecase.execute(null);
    final profile = profileResult.fold((_) => null, (p) => p);
    final budgets = profile?.categoryBudgets ?? const <String, double>{};

    final txnsResult = await loadTransactionsWithTypeUsecase.execute(
      LoadTransactionsArguments(month, TypeSpending.expense),
    );
    final txns = txnsResult.fold((_) => <Transaction>[], (t) => t);
    final breakdownResult = await loadAnalysisUsecase.execute(txns);
    final breakdown = breakdownResult.fold((_) => <Analysis>[], (a) => a);
    final spentById = {for (final a in breakdown) a.category.id: a};

    final categoriesResult = await loadCategoryUsecase.execute(
      CategoryType.expense,
    );
    final categories = categoriesResult.fold((_) => <Category>[], (c) => c);
    final categoryById = {for (final c in categories) c.id: c};

    final ids = <String>{...budgets.keys, ...spentById.keys};
    final rows = <CategoryBudgetProgress>[];
    for (final id in ids) {
      final analysis = spentById[id];
      final category = analysis?.category ?? categoryById[id];
      if (category == null) continue; // stale/unknown id
      final spent = analysis?.cash ?? 0.0;
      final max = budgets[id] ?? 0.0;
      if (max <= 0 && spent <= 0) continue;
      rows.add(
        CategoryBudgetProgress(
          categoryId: id,
          title: category.title,
          icon: category.icon,
          spent: spent,
          max: max,
        ),
      );
    }
    // Over-budget categories first, then by amount spent.
    rows.sort((a, b) {
      if (a.isOverBudget != b.isOverBudget) return a.isOverBudget ? -1 : 1;
      return b.spent.compareTo(a.spent);
    });
    return rows;
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(
      AnalysisState.loading(
        data: AnalysisData(
          currentMonth: DateTime.now(),
          transactions: [],
          segments: [],
        ),
      ),
    );

    final result = await loadTransactionsWithTypeUsecase.execute(
      LoadTransactionsArguments(DateTime.now(), TypeSpending.expense),
    );

    await result.fold(
      (failure) async {
        emit(AnalysisState.error(failure.toString()));
      },
      (transactions) async {
        final expenseResult = await getExpenseAmountUseCase.execute(
          transactions,
        );
        final incomeResult = await getIncomeAmountUseCase.execute(transactions);
        final segmentResult = await segmentPersentageUsecase.execute(
          transactions,
        );
        final analysisResult = await loadAnalysisUsecase.execute(transactions);

        double expenseAmount = 0;
        double incomeAmount = 0;
        List<Segment> segmentList = [];
        List<Analysis> analysisList = [];

        expenseResult.fold(
          (failure) => emit(AnalysisState.error(failure.toString())),
          (amount) => expenseAmount = amount,
        );

        incomeResult.fold(
          (failure) => emit(AnalysisState.error(failure.toString())),
          (amount) => incomeAmount = amount,
        );

        segmentResult.fold(
          (failure) => emit(AnalysisState.error(failure.toString())),
          (segments) => segmentList = segments,
        );

        analysisResult.fold(
          (failure) => emit(AnalysisState.error(failure.toString())),
          (analysis) => analysisList = analysis,
        );

        final categoryBudgets = await _loadCategoryBudgets(DateTime.now());

        emit(
          AnalysisState.loaded(
            data: AnalysisData(
              currentMonth: DateTime.now(),
              transactions: transactions,
              segments: segmentList,
              expenseAmount: expenseAmount,
              incomeAmount: incomeAmount,
              analysis: analysisList,
              categoryBudgets: categoryBudgets,
            ),
          ),
        );

        // Auto-resolve AI insights: reuses the cached result when nothing
        // changed, only calling Gemini when the spending fingerprint differs.
        add(const AnalysisEvent.loadAiInsights());
      },
    );
  }

  Future<void> _onUpdateTransactions(
    UpdateTransactions event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(
      AnalysisState.loading(
        data: AnalysisData(
          currentMonth: event.month,
          transactions: [],
          segments: [],
        ),
      ),
    );

    final result = await loadTransactionsWithTypeUsecase.execute(
      LoadTransactionsArguments(event.month, event.typeSpending),
    );

    await result.fold(
      (failure) async {
        emit(AnalysisState.error(failure.toString()));
      },
      (transactions) async {
        final expenseResult = await getExpenseAmountUseCase.execute(
          transactions,
        );
        final incomeResult = await getIncomeAmountUseCase.execute(transactions);
        final segmentResult = await segmentPersentageUsecase.execute(
          transactions,
        );
        final analysisResult = await loadAnalysisUsecase.execute(transactions);

        double expenseAmount = 0;
        double incomeAmount = 0;
        List<Segment> segmentList = [];
        List<Analysis> analysisList = [];

        expenseResult.fold(
          (failure) => emit(AnalysisState.error(failure.toString())),
          (amount) => expenseAmount = amount,
        );

        incomeResult.fold(
          (failure) => emit(AnalysisState.error(failure.toString())),
          (amount) => incomeAmount = amount,
        );

        segmentResult.fold(
          (failure) => emit(AnalysisState.error(failure.toString())),
          (segments) => segmentList = segments,
        );

        analysisResult.fold(
          (failure) => emit(AnalysisState.error(failure.toString())),
          (analysis) => analysisList = analysis,
        );

        final categoryBudgets = await _loadCategoryBudgets(event.month);

        emit(
          AnalysisState.loaded(
            data: AnalysisData(
              selectedType: event.typeSpending,
              currentMonth: event.month,
              transactions: transactions,
              segments: segmentList,
              expenseAmount: expenseAmount,
              incomeAmount: incomeAmount,
              analysis: analysisList,
              categoryBudgets: categoryBudgets,
            ),
          ),
        );

        // Keep AI insights budget-focused: only auto-resolve for the expense
        // breakdown, and rely on the cache to avoid redundant Gemini calls.
        if (event.typeSpending == TypeSpending.expense) {
          add(const AnalysisEvent.loadAiInsights());
        }
      },
    );
  }

  /// Resolves AI insights for the period currently shown.
  ///
  /// Token policy: a fresh Gemini call happens only when the user explicitly
  /// asks ([LoadAiInsights.forceRefresh]) or when viewing the *current* month
  /// with no cached result. Browsing past months reuses each month's cached
  /// analysis (or shows an idle prompt) and never spends tokens automatically.
  Future<void> _onLoadAiInsights(
    LoadAiInsights event,
    Emitter<AnalysisState> emit,
  ) async {
    final data = state.mapOrNull(loaded: (s) => s.data);
    if (data == null) return;

    final profileResult = await loadFinancialProfileUsecase.execute(null);
    final profile = profileResult.fold((_) => null, (profile) => profile);
    if (profile == null) {
      emit(
        AnalysisState.loaded(
          data: data.copyWith(
            aiLoading: false,
            aiError: AppStrings.aiNoProfile,
          ),
        ),
      );
      return;
    }

    final isCurrentMonth = _isCurrentMonth(data.currentMonth);
    // Only show the loading state when we might actually call Gemini; passive
    // browsing of past months resolves instantly from cache without a spinner.
    if (event.forceRefresh || isCurrentMonth) {
      emit(
        AnalysisState.loaded(
          data: data.copyWith(aiLoading: true, aiError: null),
        ),
      );
    }

    final result = await getFinancialAnalysisUseCase.execute(
      FinancialAnalysisArguments(
        profile: profile,
        categoryBudgets: data.categoryBudgets,
        totalExpense: data.expenseAmount,
        totalIncome: data.incomeAmount,
        month: data.currentMonth,
        forceRefresh: event.forceRefresh,
        autoGenerateOnMiss: isCurrentMonth,
      ),
    );

    result.fold(
      (failure) => emit(
        AnalysisState.loaded(
          data: data.copyWith(aiLoading: false, aiError: failure.message),
        ),
      ),
      (analysis) {
        if (analysis == null) {
          // Idle: no cached analysis for this (past) month and we didn't
          // generate one. The card shows an "Analyse" prompt.
          emit(
            AnalysisState.loaded(
              data: data.copyWith(aiLoading: false, aiError: null),
            ),
          );
        } else {
          emit(
            AnalysisState.loaded(
              data: data.copyWith(
                aiLoading: false,
                aiAnalysis: analysis,
                aiError: null,
              ),
            ),
          );
        }
      },
    );
  }

  bool _isCurrentMonth(DateTime month) {
    final now = DateTime.now();
    return month.year == now.year && month.month == now.month;
  }

  /// Persists a new budget ("max") for one category, updates the card in place
  /// and re-resolves AI insights (the fingerprint changed, so this recomputes).
  Future<void> _onUpdateCategoryBudget(
    UpdateCategoryBudget event,
    Emitter<AnalysisState> emit,
  ) async {
    final data = state.mapOrNull(loaded: (s) => s.data);
    if (data == null) return;

    final profileResult = await loadFinancialProfileUsecase.execute(null);
    final profile = profileResult.fold((_) => null, (profile) => profile);
    if (profile == null) return;

    final updatedBudgets = Map<String, double>.from(profile.categoryBudgets)
      ..[event.categoryId] = event.value;
    final saveResult = await saveFinancialProfileUsecase.execute(
      profile.copyWith(categoryBudgets: updatedBudgets),
    );

    await saveResult.fold((_) async {}, (_) async {
      // Reflect the new max in the existing rows, keeping over-budget first.
      final rows =
          data.categoryBudgets
              .map(
                (row) => row.categoryId == event.categoryId
                    ? row.copyWith(max: event.value)
                    : row,
              )
              .toList()
            ..sort((a, b) {
              if (a.isOverBudget != b.isOverBudget) {
                return a.isOverBudget ? -1 : 1;
              }
              return b.spent.compareTo(a.spent);
            });
      emit(AnalysisState.loaded(data: data.copyWith(categoryBudgets: rows)));
      add(const AnalysisEvent.loadAiInsights());
    });
  }
}
