import 'package:finance_app/domain/models/category.dart';
import 'package:finance_app/domain/models/financial_profile.dart';
import 'package:finance_app/domain/usecases.dart/category/load_category_usecase.dart';
import 'package:finance_app/domain/usecases.dart/financial_profile/save_financial_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_bloc.freezed.dart';

/// The single-value numeric fields captured by the survey.
enum SurveyField {
  salary,
  otherIncome,
  housePayment,
  carPayment,
  utilitiesPayment,
}

/// Number of steps in the survey flow (about you, income, fixed, budgets).
const int kSurveyStepCount = 4;

@freezed
class SurveyData with _$SurveyData {
  const SurveyData._();

  const factory SurveyData({
    @Default(0) int step,
    // Step 0 — about you.
    FinancialGoal? goal,
    @Default('USD') String currencyCode,
    @Default(PayFrequency.monthly) PayFrequency payFrequency,
    @Default('') String salary,
    @Default('') String otherIncome,
    @Default('') String housePayment,
    @Default('') String carPayment,
    @Default('') String utilitiesPayment,
    // Budget text per expense category, keyed by category id.
    @Default({}) Map<String, String> categoryBudgets,
    @Default([]) List<Category> expenseCategories,
    String? errorMessage,
  }) = _SurveyData;

  String valueOf(SurveyField field) {
    switch (field) {
      case SurveyField.salary:
        return salary;
      case SurveyField.otherIncome:
        return otherIncome;
      case SurveyField.housePayment:
        return housePayment;
      case SurveyField.carPayment:
        return carPayment;
      case SurveyField.utilitiesPayment:
        return utilitiesPayment;
    }
  }
}

@freezed
class SurveyEvent with _$SurveyEvent {
  const factory SurveyEvent.started() = SurveyStarted;
  const factory SurveyEvent.goalChanged(FinancialGoal goal) = SurveyGoalChanged;
  const factory SurveyEvent.currencyChanged(String currencyCode) =
      SurveyCurrencyChanged;
  const factory SurveyEvent.payFrequencyChanged(PayFrequency frequency) =
      SurveyPayFrequencyChanged;
  const factory SurveyEvent.fieldChanged(SurveyField field, String value) =
      SurveyFieldChanged;
  const factory SurveyEvent.budgetChanged(String categoryId, String value) =
      SurveyBudgetChanged;
  const factory SurveyEvent.nextStep() = SurveyNextStep;
  const factory SurveyEvent.previousStep() = SurveyPreviousStep;
  const factory SurveyEvent.submitted() = SurveySubmitted;
}

@freezed
class SurveyState with _$SurveyState {
  const factory SurveyState.loading() = SurveyLoading;
  const factory SurveyState.editing(SurveyData data) = SurveyEditing;
  const factory SurveyState.submitting(SurveyData data) = SurveySubmitting;
  const factory SurveyState.success() = SurveySuccess;
  const factory SurveyState.error(String message) = SurveyError;
}

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final LoadCategoryUsecase loadCategoryUsecase;
  final SaveFinancialProfileUsecase saveFinancialProfileUsecase;

  SurveyData _data = const SurveyData();

  SurveyBloc(this.loadCategoryUsecase, this.saveFinancialProfileUsecase)
    : super(const SurveyState.loading()) {
    on<SurveyStarted>(_onStarted);
    on<SurveyGoalChanged>(_onGoalChanged);
    on<SurveyCurrencyChanged>(_onCurrencyChanged);
    on<SurveyPayFrequencyChanged>(_onPayFrequencyChanged);
    on<SurveyFieldChanged>(_onFieldChanged);
    on<SurveyBudgetChanged>(_onBudgetChanged);
    on<SurveyNextStep>(_onNextStep);
    on<SurveyPreviousStep>(_onPreviousStep);
    on<SurveySubmitted>(_onSubmitted);
  }

  Future<void> _onStarted(
    SurveyStarted event,
    Emitter<SurveyState> emit,
  ) async {
    emit(const SurveyState.loading());
    final result = await loadCategoryUsecase.execute(CategoryType.expense);
    result.fold((failure) => emit(SurveyState.error(failure.message)), (
      categories,
    ) {
      _data = _data.copyWith(expenseCategories: categories);
      emit(SurveyState.editing(_data));
    });
  }

  void _onGoalChanged(SurveyGoalChanged event, Emitter<SurveyState> emit) {
    _data = _data.copyWith(goal: event.goal, errorMessage: null);
    emit(SurveyState.editing(_data));
  }

  void _onCurrencyChanged(
    SurveyCurrencyChanged event,
    Emitter<SurveyState> emit,
  ) {
    _data = _data.copyWith(
      currencyCode: event.currencyCode,
      errorMessage: null,
    );
    emit(SurveyState.editing(_data));
  }

  void _onPayFrequencyChanged(
    SurveyPayFrequencyChanged event,
    Emitter<SurveyState> emit,
  ) {
    _data = _data.copyWith(payFrequency: event.frequency, errorMessage: null);
    emit(SurveyState.editing(_data));
  }

  void _onFieldChanged(SurveyFieldChanged event, Emitter<SurveyState> emit) {
    switch (event.field) {
      case SurveyField.salary:
        _data = _data.copyWith(salary: event.value);
        break;
      case SurveyField.otherIncome:
        _data = _data.copyWith(otherIncome: event.value);
        break;
      case SurveyField.housePayment:
        _data = _data.copyWith(housePayment: event.value);
        break;
      case SurveyField.carPayment:
        _data = _data.copyWith(carPayment: event.value);
        break;
      case SurveyField.utilitiesPayment:
        _data = _data.copyWith(utilitiesPayment: event.value);
        break;
    }
    _data = _data.copyWith(errorMessage: null);
    emit(SurveyState.editing(_data));
  }

  void _onBudgetChanged(SurveyBudgetChanged event, Emitter<SurveyState> emit) {
    final budgets = Map<String, String>.from(_data.categoryBudgets);
    budgets[event.categoryId] = event.value;
    _data = _data.copyWith(categoryBudgets: budgets, errorMessage: null);
    emit(SurveyState.editing(_data));
  }

  void _onNextStep(SurveyNextStep event, Emitter<SurveyState> emit) {
    final error = _validateStep(_data.step);
    if (error != null) {
      _data = _data.copyWith(errorMessage: error);
      emit(SurveyState.editing(_data));
      return;
    }
    if (_data.step < kSurveyStepCount - 1) {
      _data = _data.copyWith(step: _data.step + 1, errorMessage: null);
      emit(SurveyState.editing(_data));
    }
  }

  void _onPreviousStep(SurveyPreviousStep event, Emitter<SurveyState> emit) {
    if (_data.step > 0) {
      _data = _data.copyWith(step: _data.step - 1, errorMessage: null);
      emit(SurveyState.editing(_data));
    }
  }

  Future<void> _onSubmitted(
    SurveySubmitted event,
    Emitter<SurveyState> emit,
  ) async {
    // Validate every step so submission can't skip required fields.
    for (var step = 0; step < kSurveyStepCount; step++) {
      final error = _validateStep(step);
      if (error != null) {
        _data = _data.copyWith(step: step, errorMessage: error);
        emit(SurveyState.editing(_data));
        return;
      }
    }

    emit(SurveyState.submitting(_data));
    final profile = FinancialProfile(
      goal: _data.goal,
      currencyCode: _data.currencyCode,
      payFrequency: _data.payFrequency,
      salary: _parse(_data.salary),
      otherIncome: _parse(_data.otherIncome),
      housePayment: _parse(_data.housePayment),
      carPayment: _parse(_data.carPayment),
      utilitiesPayment: _parse(_data.utilitiesPayment),
      categoryBudgets: _data.categoryBudgets.map(
        (key, value) => MapEntry(key, _parse(value)),
      ),
    );

    final result = await saveFinancialProfileUsecase.execute(profile);
    result.fold((failure) {
      _data = _data.copyWith(errorMessage: failure.message);
      emit(SurveyState.editing(_data));
    }, (_) => emit(const SurveyState.success()));
  }

  /// Returns an error message when [step] has invalid input, else null.
  String? _validateStep(int step) {
    switch (step) {
      case 0:
        if (_data.goal == null) {
          return 'Pick what you want to focus on';
        }
        return null;
      case 1:
        if (!_isValidRequired(_data.salary)) {
          return 'Enter a valid salary amount';
        }
        if (!_isValidOptional(_data.otherIncome)) {
          return 'Other income must be a number';
        }
        return null;
      case 2:
        if (!_isValidRequired(_data.housePayment) ||
            !_isValidRequired(_data.carPayment) ||
            !_isValidRequired(_data.utilitiesPayment)) {
          return 'Enter valid amounts for house, car and utilities';
        }
        return null;
      case 3:
        for (final value in _data.categoryBudgets.values) {
          if (!_isValidOptional(value)) {
            return 'Budgets must be valid numbers';
          }
        }
        return null;
      default:
        return null;
    }
  }

  /// Required: must be present and a non-negative number.
  bool _isValidRequired(String value) {
    final parsed = double.tryParse(value.trim());
    return parsed != null && parsed >= 0;
  }

  /// Optional: empty is fine, otherwise must be a non-negative number.
  bool _isValidOptional(String value) {
    if (value.trim().isEmpty) return true;
    final parsed = double.tryParse(value.trim());
    return parsed != null && parsed >= 0;
  }

  double _parse(String value) => double.tryParse(value.trim()) ?? 0.0;
}
