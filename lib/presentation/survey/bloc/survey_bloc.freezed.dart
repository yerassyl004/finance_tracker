// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'survey_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SurveyData {
  int get step => throw _privateConstructorUsedError; // Step 0 — about you.
  FinancialGoal? get goal => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  PayFrequency get payFrequency => throw _privateConstructorUsedError;
  String get salary => throw _privateConstructorUsedError;
  String get otherIncome => throw _privateConstructorUsedError;
  String get housePayment => throw _privateConstructorUsedError;
  String get carPayment => throw _privateConstructorUsedError;
  String get utilitiesPayment =>
      throw _privateConstructorUsedError; // Budget text per expense category, keyed by category id.
  Map<String, String> get categoryBudgets => throw _privateConstructorUsedError;
  List<Category> get expenseCategories => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of SurveyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SurveyDataCopyWith<SurveyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurveyDataCopyWith<$Res> {
  factory $SurveyDataCopyWith(
    SurveyData value,
    $Res Function(SurveyData) then,
  ) = _$SurveyDataCopyWithImpl<$Res, SurveyData>;
  @useResult
  $Res call({
    int step,
    FinancialGoal? goal,
    String currencyCode,
    PayFrequency payFrequency,
    String salary,
    String otherIncome,
    String housePayment,
    String carPayment,
    String utilitiesPayment,
    Map<String, String> categoryBudgets,
    List<Category> expenseCategories,
    String? errorMessage,
  });
}

/// @nodoc
class _$SurveyDataCopyWithImpl<$Res, $Val extends SurveyData>
    implements $SurveyDataCopyWith<$Res> {
  _$SurveyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SurveyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? goal = freezed,
    Object? currencyCode = null,
    Object? payFrequency = null,
    Object? salary = null,
    Object? otherIncome = null,
    Object? housePayment = null,
    Object? carPayment = null,
    Object? utilitiesPayment = null,
    Object? categoryBudgets = null,
    Object? expenseCategories = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            step: null == step
                ? _value.step
                : step // ignore: cast_nullable_to_non_nullable
                      as int,
            goal: freezed == goal
                ? _value.goal
                : goal // ignore: cast_nullable_to_non_nullable
                      as FinancialGoal?,
            currencyCode: null == currencyCode
                ? _value.currencyCode
                : currencyCode // ignore: cast_nullable_to_non_nullable
                      as String,
            payFrequency: null == payFrequency
                ? _value.payFrequency
                : payFrequency // ignore: cast_nullable_to_non_nullable
                      as PayFrequency,
            salary: null == salary
                ? _value.salary
                : salary // ignore: cast_nullable_to_non_nullable
                      as String,
            otherIncome: null == otherIncome
                ? _value.otherIncome
                : otherIncome // ignore: cast_nullable_to_non_nullable
                      as String,
            housePayment: null == housePayment
                ? _value.housePayment
                : housePayment // ignore: cast_nullable_to_non_nullable
                      as String,
            carPayment: null == carPayment
                ? _value.carPayment
                : carPayment // ignore: cast_nullable_to_non_nullable
                      as String,
            utilitiesPayment: null == utilitiesPayment
                ? _value.utilitiesPayment
                : utilitiesPayment // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryBudgets: null == categoryBudgets
                ? _value.categoryBudgets
                : categoryBudgets // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            expenseCategories: null == expenseCategories
                ? _value.expenseCategories
                : expenseCategories // ignore: cast_nullable_to_non_nullable
                      as List<Category>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SurveyDataImplCopyWith<$Res>
    implements $SurveyDataCopyWith<$Res> {
  factory _$$SurveyDataImplCopyWith(
    _$SurveyDataImpl value,
    $Res Function(_$SurveyDataImpl) then,
  ) = __$$SurveyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int step,
    FinancialGoal? goal,
    String currencyCode,
    PayFrequency payFrequency,
    String salary,
    String otherIncome,
    String housePayment,
    String carPayment,
    String utilitiesPayment,
    Map<String, String> categoryBudgets,
    List<Category> expenseCategories,
    String? errorMessage,
  });
}

/// @nodoc
class __$$SurveyDataImplCopyWithImpl<$Res>
    extends _$SurveyDataCopyWithImpl<$Res, _$SurveyDataImpl>
    implements _$$SurveyDataImplCopyWith<$Res> {
  __$$SurveyDataImplCopyWithImpl(
    _$SurveyDataImpl _value,
    $Res Function(_$SurveyDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? goal = freezed,
    Object? currencyCode = null,
    Object? payFrequency = null,
    Object? salary = null,
    Object? otherIncome = null,
    Object? housePayment = null,
    Object? carPayment = null,
    Object? utilitiesPayment = null,
    Object? categoryBudgets = null,
    Object? expenseCategories = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$SurveyDataImpl(
        step: null == step
            ? _value.step
            : step // ignore: cast_nullable_to_non_nullable
                  as int,
        goal: freezed == goal
            ? _value.goal
            : goal // ignore: cast_nullable_to_non_nullable
                  as FinancialGoal?,
        currencyCode: null == currencyCode
            ? _value.currencyCode
            : currencyCode // ignore: cast_nullable_to_non_nullable
                  as String,
        payFrequency: null == payFrequency
            ? _value.payFrequency
            : payFrequency // ignore: cast_nullable_to_non_nullable
                  as PayFrequency,
        salary: null == salary
            ? _value.salary
            : salary // ignore: cast_nullable_to_non_nullable
                  as String,
        otherIncome: null == otherIncome
            ? _value.otherIncome
            : otherIncome // ignore: cast_nullable_to_non_nullable
                  as String,
        housePayment: null == housePayment
            ? _value.housePayment
            : housePayment // ignore: cast_nullable_to_non_nullable
                  as String,
        carPayment: null == carPayment
            ? _value.carPayment
            : carPayment // ignore: cast_nullable_to_non_nullable
                  as String,
        utilitiesPayment: null == utilitiesPayment
            ? _value.utilitiesPayment
            : utilitiesPayment // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryBudgets: null == categoryBudgets
            ? _value._categoryBudgets
            : categoryBudgets // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        expenseCategories: null == expenseCategories
            ? _value._expenseCategories
            : expenseCategories // ignore: cast_nullable_to_non_nullable
                  as List<Category>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SurveyDataImpl extends _SurveyData {
  const _$SurveyDataImpl({
    this.step = 0,
    this.goal,
    this.currencyCode = 'USD',
    this.payFrequency = PayFrequency.monthly,
    this.salary = '',
    this.otherIncome = '',
    this.housePayment = '',
    this.carPayment = '',
    this.utilitiesPayment = '',
    final Map<String, String> categoryBudgets = const {},
    final List<Category> expenseCategories = const [],
    this.errorMessage,
  }) : _categoryBudgets = categoryBudgets,
       _expenseCategories = expenseCategories,
       super._();

  @override
  @JsonKey()
  final int step;
  // Step 0 — about you.
  @override
  final FinancialGoal? goal;
  @override
  @JsonKey()
  final String currencyCode;
  @override
  @JsonKey()
  final PayFrequency payFrequency;
  @override
  @JsonKey()
  final String salary;
  @override
  @JsonKey()
  final String otherIncome;
  @override
  @JsonKey()
  final String housePayment;
  @override
  @JsonKey()
  final String carPayment;
  @override
  @JsonKey()
  final String utilitiesPayment;
  // Budget text per expense category, keyed by category id.
  final Map<String, String> _categoryBudgets;
  // Budget text per expense category, keyed by category id.
  @override
  @JsonKey()
  Map<String, String> get categoryBudgets {
    if (_categoryBudgets is EqualUnmodifiableMapView) return _categoryBudgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryBudgets);
  }

  final List<Category> _expenseCategories;
  @override
  @JsonKey()
  List<Category> get expenseCategories {
    if (_expenseCategories is EqualUnmodifiableListView)
      return _expenseCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseCategories);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SurveyData(step: $step, goal: $goal, currencyCode: $currencyCode, payFrequency: $payFrequency, salary: $salary, otherIncome: $otherIncome, housePayment: $housePayment, carPayment: $carPayment, utilitiesPayment: $utilitiesPayment, categoryBudgets: $categoryBudgets, expenseCategories: $expenseCategories, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyDataImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.payFrequency, payFrequency) ||
                other.payFrequency == payFrequency) &&
            (identical(other.salary, salary) || other.salary == salary) &&
            (identical(other.otherIncome, otherIncome) ||
                other.otherIncome == otherIncome) &&
            (identical(other.housePayment, housePayment) ||
                other.housePayment == housePayment) &&
            (identical(other.carPayment, carPayment) ||
                other.carPayment == carPayment) &&
            (identical(other.utilitiesPayment, utilitiesPayment) ||
                other.utilitiesPayment == utilitiesPayment) &&
            const DeepCollectionEquality().equals(
              other._categoryBudgets,
              _categoryBudgets,
            ) &&
            const DeepCollectionEquality().equals(
              other._expenseCategories,
              _expenseCategories,
            ) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    step,
    goal,
    currencyCode,
    payFrequency,
    salary,
    otherIncome,
    housePayment,
    carPayment,
    utilitiesPayment,
    const DeepCollectionEquality().hash(_categoryBudgets),
    const DeepCollectionEquality().hash(_expenseCategories),
    errorMessage,
  );

  /// Create a copy of SurveyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyDataImplCopyWith<_$SurveyDataImpl> get copyWith =>
      __$$SurveyDataImplCopyWithImpl<_$SurveyDataImpl>(this, _$identity);
}

abstract class _SurveyData extends SurveyData {
  const factory _SurveyData({
    final int step,
    final FinancialGoal? goal,
    final String currencyCode,
    final PayFrequency payFrequency,
    final String salary,
    final String otherIncome,
    final String housePayment,
    final String carPayment,
    final String utilitiesPayment,
    final Map<String, String> categoryBudgets,
    final List<Category> expenseCategories,
    final String? errorMessage,
  }) = _$SurveyDataImpl;
  const _SurveyData._() : super._();

  @override
  int get step; // Step 0 — about you.
  @override
  FinancialGoal? get goal;
  @override
  String get currencyCode;
  @override
  PayFrequency get payFrequency;
  @override
  String get salary;
  @override
  String get otherIncome;
  @override
  String get housePayment;
  @override
  String get carPayment;
  @override
  String get utilitiesPayment; // Budget text per expense category, keyed by category id.
  @override
  Map<String, String> get categoryBudgets;
  @override
  List<Category> get expenseCategories;
  @override
  String? get errorMessage;

  /// Create a copy of SurveyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyDataImplCopyWith<_$SurveyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SurveyEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurveyEventCopyWith<$Res> {
  factory $SurveyEventCopyWith(
    SurveyEvent value,
    $Res Function(SurveyEvent) then,
  ) = _$SurveyEventCopyWithImpl<$Res, SurveyEvent>;
}

/// @nodoc
class _$SurveyEventCopyWithImpl<$Res, $Val extends SurveyEvent>
    implements $SurveyEventCopyWith<$Res> {
  _$SurveyEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SurveyStartedImplCopyWith<$Res> {
  factory _$$SurveyStartedImplCopyWith(
    _$SurveyStartedImpl value,
    $Res Function(_$SurveyStartedImpl) then,
  ) = __$$SurveyStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SurveyStartedImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveyStartedImpl>
    implements _$$SurveyStartedImplCopyWith<$Res> {
  __$$SurveyStartedImplCopyWithImpl(
    _$SurveyStartedImpl _value,
    $Res Function(_$SurveyStartedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SurveyStartedImpl implements SurveyStarted {
  const _$SurveyStartedImpl();

  @override
  String toString() {
    return 'SurveyEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SurveyStartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class SurveyStarted implements SurveyEvent {
  const factory SurveyStarted() = _$SurveyStartedImpl;
}

/// @nodoc
abstract class _$$SurveyGoalChangedImplCopyWith<$Res> {
  factory _$$SurveyGoalChangedImplCopyWith(
    _$SurveyGoalChangedImpl value,
    $Res Function(_$SurveyGoalChangedImpl) then,
  ) = __$$SurveyGoalChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({FinancialGoal goal});
}

/// @nodoc
class __$$SurveyGoalChangedImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveyGoalChangedImpl>
    implements _$$SurveyGoalChangedImplCopyWith<$Res> {
  __$$SurveyGoalChangedImplCopyWithImpl(
    _$SurveyGoalChangedImpl _value,
    $Res Function(_$SurveyGoalChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? goal = null}) {
    return _then(
      _$SurveyGoalChangedImpl(
        null == goal
            ? _value.goal
            : goal // ignore: cast_nullable_to_non_nullable
                  as FinancialGoal,
      ),
    );
  }
}

/// @nodoc

class _$SurveyGoalChangedImpl implements SurveyGoalChanged {
  const _$SurveyGoalChangedImpl(this.goal);

  @override
  final FinancialGoal goal;

  @override
  String toString() {
    return 'SurveyEvent.goalChanged(goal: $goal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyGoalChangedImpl &&
            (identical(other.goal, goal) || other.goal == goal));
  }

  @override
  int get hashCode => Object.hash(runtimeType, goal);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyGoalChangedImplCopyWith<_$SurveyGoalChangedImpl> get copyWith =>
      __$$SurveyGoalChangedImplCopyWithImpl<_$SurveyGoalChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return goalChanged(goal);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return goalChanged?.call(goal);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (goalChanged != null) {
      return goalChanged(goal);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return goalChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return goalChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (goalChanged != null) {
      return goalChanged(this);
    }
    return orElse();
  }
}

abstract class SurveyGoalChanged implements SurveyEvent {
  const factory SurveyGoalChanged(final FinancialGoal goal) =
      _$SurveyGoalChangedImpl;

  FinancialGoal get goal;

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyGoalChangedImplCopyWith<_$SurveyGoalChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SurveyCurrencyChangedImplCopyWith<$Res> {
  factory _$$SurveyCurrencyChangedImplCopyWith(
    _$SurveyCurrencyChangedImpl value,
    $Res Function(_$SurveyCurrencyChangedImpl) then,
  ) = __$$SurveyCurrencyChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String currencyCode});
}

/// @nodoc
class __$$SurveyCurrencyChangedImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveyCurrencyChangedImpl>
    implements _$$SurveyCurrencyChangedImplCopyWith<$Res> {
  __$$SurveyCurrencyChangedImplCopyWithImpl(
    _$SurveyCurrencyChangedImpl _value,
    $Res Function(_$SurveyCurrencyChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currencyCode = null}) {
    return _then(
      _$SurveyCurrencyChangedImpl(
        null == currencyCode
            ? _value.currencyCode
            : currencyCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SurveyCurrencyChangedImpl implements SurveyCurrencyChanged {
  const _$SurveyCurrencyChangedImpl(this.currencyCode);

  @override
  final String currencyCode;

  @override
  String toString() {
    return 'SurveyEvent.currencyChanged(currencyCode: $currencyCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyCurrencyChangedImpl &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currencyCode);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyCurrencyChangedImplCopyWith<_$SurveyCurrencyChangedImpl>
  get copyWith =>
      __$$SurveyCurrencyChangedImplCopyWithImpl<_$SurveyCurrencyChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return currencyChanged(currencyCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return currencyChanged?.call(currencyCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (currencyChanged != null) {
      return currencyChanged(currencyCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return currencyChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return currencyChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (currencyChanged != null) {
      return currencyChanged(this);
    }
    return orElse();
  }
}

abstract class SurveyCurrencyChanged implements SurveyEvent {
  const factory SurveyCurrencyChanged(final String currencyCode) =
      _$SurveyCurrencyChangedImpl;

  String get currencyCode;

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyCurrencyChangedImplCopyWith<_$SurveyCurrencyChangedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SurveyPayFrequencyChangedImplCopyWith<$Res> {
  factory _$$SurveyPayFrequencyChangedImplCopyWith(
    _$SurveyPayFrequencyChangedImpl value,
    $Res Function(_$SurveyPayFrequencyChangedImpl) then,
  ) = __$$SurveyPayFrequencyChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PayFrequency frequency});
}

/// @nodoc
class __$$SurveyPayFrequencyChangedImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveyPayFrequencyChangedImpl>
    implements _$$SurveyPayFrequencyChangedImplCopyWith<$Res> {
  __$$SurveyPayFrequencyChangedImplCopyWithImpl(
    _$SurveyPayFrequencyChangedImpl _value,
    $Res Function(_$SurveyPayFrequencyChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? frequency = null}) {
    return _then(
      _$SurveyPayFrequencyChangedImpl(
        null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as PayFrequency,
      ),
    );
  }
}

/// @nodoc

class _$SurveyPayFrequencyChangedImpl implements SurveyPayFrequencyChanged {
  const _$SurveyPayFrequencyChangedImpl(this.frequency);

  @override
  final PayFrequency frequency;

  @override
  String toString() {
    return 'SurveyEvent.payFrequencyChanged(frequency: $frequency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyPayFrequencyChangedImpl &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency));
  }

  @override
  int get hashCode => Object.hash(runtimeType, frequency);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyPayFrequencyChangedImplCopyWith<_$SurveyPayFrequencyChangedImpl>
  get copyWith =>
      __$$SurveyPayFrequencyChangedImplCopyWithImpl<
        _$SurveyPayFrequencyChangedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return payFrequencyChanged(frequency);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return payFrequencyChanged?.call(frequency);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (payFrequencyChanged != null) {
      return payFrequencyChanged(frequency);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return payFrequencyChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return payFrequencyChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (payFrequencyChanged != null) {
      return payFrequencyChanged(this);
    }
    return orElse();
  }
}

abstract class SurveyPayFrequencyChanged implements SurveyEvent {
  const factory SurveyPayFrequencyChanged(final PayFrequency frequency) =
      _$SurveyPayFrequencyChangedImpl;

  PayFrequency get frequency;

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyPayFrequencyChangedImplCopyWith<_$SurveyPayFrequencyChangedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SurveyFieldChangedImplCopyWith<$Res> {
  factory _$$SurveyFieldChangedImplCopyWith(
    _$SurveyFieldChangedImpl value,
    $Res Function(_$SurveyFieldChangedImpl) then,
  ) = __$$SurveyFieldChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SurveyField field, String value});
}

/// @nodoc
class __$$SurveyFieldChangedImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveyFieldChangedImpl>
    implements _$$SurveyFieldChangedImplCopyWith<$Res> {
  __$$SurveyFieldChangedImplCopyWithImpl(
    _$SurveyFieldChangedImpl _value,
    $Res Function(_$SurveyFieldChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field = null, Object? value = null}) {
    return _then(
      _$SurveyFieldChangedImpl(
        null == field
            ? _value.field
            : field // ignore: cast_nullable_to_non_nullable
                  as SurveyField,
        null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SurveyFieldChangedImpl implements SurveyFieldChanged {
  const _$SurveyFieldChangedImpl(this.field, this.value);

  @override
  final SurveyField field;
  @override
  final String value;

  @override
  String toString() {
    return 'SurveyEvent.fieldChanged(field: $field, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyFieldChangedImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field, value);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyFieldChangedImplCopyWith<_$SurveyFieldChangedImpl> get copyWith =>
      __$$SurveyFieldChangedImplCopyWithImpl<_$SurveyFieldChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return fieldChanged(field, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return fieldChanged?.call(field, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (fieldChanged != null) {
      return fieldChanged(field, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return fieldChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return fieldChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (fieldChanged != null) {
      return fieldChanged(this);
    }
    return orElse();
  }
}

abstract class SurveyFieldChanged implements SurveyEvent {
  const factory SurveyFieldChanged(
    final SurveyField field,
    final String value,
  ) = _$SurveyFieldChangedImpl;

  SurveyField get field;
  String get value;

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyFieldChangedImplCopyWith<_$SurveyFieldChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SurveyBudgetChangedImplCopyWith<$Res> {
  factory _$$SurveyBudgetChangedImplCopyWith(
    _$SurveyBudgetChangedImpl value,
    $Res Function(_$SurveyBudgetChangedImpl) then,
  ) = __$$SurveyBudgetChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId, String value});
}

/// @nodoc
class __$$SurveyBudgetChangedImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveyBudgetChangedImpl>
    implements _$$SurveyBudgetChangedImplCopyWith<$Res> {
  __$$SurveyBudgetChangedImplCopyWithImpl(
    _$SurveyBudgetChangedImpl _value,
    $Res Function(_$SurveyBudgetChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = null, Object? value = null}) {
    return _then(
      _$SurveyBudgetChangedImpl(
        null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SurveyBudgetChangedImpl implements SurveyBudgetChanged {
  const _$SurveyBudgetChangedImpl(this.categoryId, this.value);

  @override
  final String categoryId;
  @override
  final String value;

  @override
  String toString() {
    return 'SurveyEvent.budgetChanged(categoryId: $categoryId, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyBudgetChangedImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categoryId, value);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyBudgetChangedImplCopyWith<_$SurveyBudgetChangedImpl> get copyWith =>
      __$$SurveyBudgetChangedImplCopyWithImpl<_$SurveyBudgetChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return budgetChanged(categoryId, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return budgetChanged?.call(categoryId, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (budgetChanged != null) {
      return budgetChanged(categoryId, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return budgetChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return budgetChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (budgetChanged != null) {
      return budgetChanged(this);
    }
    return orElse();
  }
}

abstract class SurveyBudgetChanged implements SurveyEvent {
  const factory SurveyBudgetChanged(
    final String categoryId,
    final String value,
  ) = _$SurveyBudgetChangedImpl;

  String get categoryId;
  String get value;

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyBudgetChangedImplCopyWith<_$SurveyBudgetChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SurveyNextStepImplCopyWith<$Res> {
  factory _$$SurveyNextStepImplCopyWith(
    _$SurveyNextStepImpl value,
    $Res Function(_$SurveyNextStepImpl) then,
  ) = __$$SurveyNextStepImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SurveyNextStepImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveyNextStepImpl>
    implements _$$SurveyNextStepImplCopyWith<$Res> {
  __$$SurveyNextStepImplCopyWithImpl(
    _$SurveyNextStepImpl _value,
    $Res Function(_$SurveyNextStepImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SurveyNextStepImpl implements SurveyNextStep {
  const _$SurveyNextStepImpl();

  @override
  String toString() {
    return 'SurveyEvent.nextStep()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SurveyNextStepImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return nextStep();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return nextStep?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (nextStep != null) {
      return nextStep();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return nextStep(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return nextStep?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (nextStep != null) {
      return nextStep(this);
    }
    return orElse();
  }
}

abstract class SurveyNextStep implements SurveyEvent {
  const factory SurveyNextStep() = _$SurveyNextStepImpl;
}

/// @nodoc
abstract class _$$SurveyPreviousStepImplCopyWith<$Res> {
  factory _$$SurveyPreviousStepImplCopyWith(
    _$SurveyPreviousStepImpl value,
    $Res Function(_$SurveyPreviousStepImpl) then,
  ) = __$$SurveyPreviousStepImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SurveyPreviousStepImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveyPreviousStepImpl>
    implements _$$SurveyPreviousStepImplCopyWith<$Res> {
  __$$SurveyPreviousStepImplCopyWithImpl(
    _$SurveyPreviousStepImpl _value,
    $Res Function(_$SurveyPreviousStepImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SurveyPreviousStepImpl implements SurveyPreviousStep {
  const _$SurveyPreviousStepImpl();

  @override
  String toString() {
    return 'SurveyEvent.previousStep()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SurveyPreviousStepImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return previousStep();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return previousStep?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (previousStep != null) {
      return previousStep();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return previousStep(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return previousStep?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (previousStep != null) {
      return previousStep(this);
    }
    return orElse();
  }
}

abstract class SurveyPreviousStep implements SurveyEvent {
  const factory SurveyPreviousStep() = _$SurveyPreviousStepImpl;
}

/// @nodoc
abstract class _$$SurveySubmittedImplCopyWith<$Res> {
  factory _$$SurveySubmittedImplCopyWith(
    _$SurveySubmittedImpl value,
    $Res Function(_$SurveySubmittedImpl) then,
  ) = __$$SurveySubmittedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SurveySubmittedImplCopyWithImpl<$Res>
    extends _$SurveyEventCopyWithImpl<$Res, _$SurveySubmittedImpl>
    implements _$$SurveySubmittedImplCopyWith<$Res> {
  __$$SurveySubmittedImplCopyWithImpl(
    _$SurveySubmittedImpl _value,
    $Res Function(_$SurveySubmittedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SurveySubmittedImpl implements SurveySubmitted {
  const _$SurveySubmittedImpl();

  @override
  String toString() {
    return 'SurveyEvent.submitted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SurveySubmittedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(FinancialGoal goal) goalChanged,
    required TResult Function(String currencyCode) currencyChanged,
    required TResult Function(PayFrequency frequency) payFrequencyChanged,
    required TResult Function(SurveyField field, String value) fieldChanged,
    required TResult Function(String categoryId, String value) budgetChanged,
    required TResult Function() nextStep,
    required TResult Function() previousStep,
    required TResult Function() submitted,
  }) {
    return submitted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(FinancialGoal goal)? goalChanged,
    TResult? Function(String currencyCode)? currencyChanged,
    TResult? Function(PayFrequency frequency)? payFrequencyChanged,
    TResult? Function(SurveyField field, String value)? fieldChanged,
    TResult? Function(String categoryId, String value)? budgetChanged,
    TResult? Function()? nextStep,
    TResult? Function()? previousStep,
    TResult? Function()? submitted,
  }) {
    return submitted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(FinancialGoal goal)? goalChanged,
    TResult Function(String currencyCode)? currencyChanged,
    TResult Function(PayFrequency frequency)? payFrequencyChanged,
    TResult Function(SurveyField field, String value)? fieldChanged,
    TResult Function(String categoryId, String value)? budgetChanged,
    TResult Function()? nextStep,
    TResult Function()? previousStep,
    TResult Function()? submitted,
    required TResult orElse(),
  }) {
    if (submitted != null) {
      return submitted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyStarted value) started,
    required TResult Function(SurveyGoalChanged value) goalChanged,
    required TResult Function(SurveyCurrencyChanged value) currencyChanged,
    required TResult Function(SurveyPayFrequencyChanged value)
    payFrequencyChanged,
    required TResult Function(SurveyFieldChanged value) fieldChanged,
    required TResult Function(SurveyBudgetChanged value) budgetChanged,
    required TResult Function(SurveyNextStep value) nextStep,
    required TResult Function(SurveyPreviousStep value) previousStep,
    required TResult Function(SurveySubmitted value) submitted,
  }) {
    return submitted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyStarted value)? started,
    TResult? Function(SurveyGoalChanged value)? goalChanged,
    TResult? Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult? Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult? Function(SurveyFieldChanged value)? fieldChanged,
    TResult? Function(SurveyBudgetChanged value)? budgetChanged,
    TResult? Function(SurveyNextStep value)? nextStep,
    TResult? Function(SurveyPreviousStep value)? previousStep,
    TResult? Function(SurveySubmitted value)? submitted,
  }) {
    return submitted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyStarted value)? started,
    TResult Function(SurveyGoalChanged value)? goalChanged,
    TResult Function(SurveyCurrencyChanged value)? currencyChanged,
    TResult Function(SurveyPayFrequencyChanged value)? payFrequencyChanged,
    TResult Function(SurveyFieldChanged value)? fieldChanged,
    TResult Function(SurveyBudgetChanged value)? budgetChanged,
    TResult Function(SurveyNextStep value)? nextStep,
    TResult Function(SurveyPreviousStep value)? previousStep,
    TResult Function(SurveySubmitted value)? submitted,
    required TResult orElse(),
  }) {
    if (submitted != null) {
      return submitted(this);
    }
    return orElse();
  }
}

abstract class SurveySubmitted implements SurveyEvent {
  const factory SurveySubmitted() = _$SurveySubmittedImpl;
}

/// @nodoc
mixin _$SurveyState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SurveyData data) editing,
    required TResult Function(SurveyData data) submitting,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SurveyData data)? editing,
    TResult? Function(SurveyData data)? submitting,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SurveyData data)? editing,
    TResult Function(SurveyData data)? submitting,
    TResult Function()? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyLoading value) loading,
    required TResult Function(SurveyEditing value) editing,
    required TResult Function(SurveySubmitting value) submitting,
    required TResult Function(SurveySuccess value) success,
    required TResult Function(SurveyError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyLoading value)? loading,
    TResult? Function(SurveyEditing value)? editing,
    TResult? Function(SurveySubmitting value)? submitting,
    TResult? Function(SurveySuccess value)? success,
    TResult? Function(SurveyError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyLoading value)? loading,
    TResult Function(SurveyEditing value)? editing,
    TResult Function(SurveySubmitting value)? submitting,
    TResult Function(SurveySuccess value)? success,
    TResult Function(SurveyError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurveyStateCopyWith<$Res> {
  factory $SurveyStateCopyWith(
    SurveyState value,
    $Res Function(SurveyState) then,
  ) = _$SurveyStateCopyWithImpl<$Res, SurveyState>;
}

/// @nodoc
class _$SurveyStateCopyWithImpl<$Res, $Val extends SurveyState>
    implements $SurveyStateCopyWith<$Res> {
  _$SurveyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SurveyLoadingImplCopyWith<$Res> {
  factory _$$SurveyLoadingImplCopyWith(
    _$SurveyLoadingImpl value,
    $Res Function(_$SurveyLoadingImpl) then,
  ) = __$$SurveyLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SurveyLoadingImplCopyWithImpl<$Res>
    extends _$SurveyStateCopyWithImpl<$Res, _$SurveyLoadingImpl>
    implements _$$SurveyLoadingImplCopyWith<$Res> {
  __$$SurveyLoadingImplCopyWithImpl(
    _$SurveyLoadingImpl _value,
    $Res Function(_$SurveyLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SurveyLoadingImpl implements SurveyLoading {
  const _$SurveyLoadingImpl();

  @override
  String toString() {
    return 'SurveyState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SurveyLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SurveyData data) editing,
    required TResult Function(SurveyData data) submitting,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SurveyData data)? editing,
    TResult? Function(SurveyData data)? submitting,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SurveyData data)? editing,
    TResult Function(SurveyData data)? submitting,
    TResult Function()? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyLoading value) loading,
    required TResult Function(SurveyEditing value) editing,
    required TResult Function(SurveySubmitting value) submitting,
    required TResult Function(SurveySuccess value) success,
    required TResult Function(SurveyError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyLoading value)? loading,
    TResult? Function(SurveyEditing value)? editing,
    TResult? Function(SurveySubmitting value)? submitting,
    TResult? Function(SurveySuccess value)? success,
    TResult? Function(SurveyError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyLoading value)? loading,
    TResult Function(SurveyEditing value)? editing,
    TResult Function(SurveySubmitting value)? submitting,
    TResult Function(SurveySuccess value)? success,
    TResult Function(SurveyError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SurveyLoading implements SurveyState {
  const factory SurveyLoading() = _$SurveyLoadingImpl;
}

/// @nodoc
abstract class _$$SurveyEditingImplCopyWith<$Res> {
  factory _$$SurveyEditingImplCopyWith(
    _$SurveyEditingImpl value,
    $Res Function(_$SurveyEditingImpl) then,
  ) = __$$SurveyEditingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SurveyData data});

  $SurveyDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$SurveyEditingImplCopyWithImpl<$Res>
    extends _$SurveyStateCopyWithImpl<$Res, _$SurveyEditingImpl>
    implements _$$SurveyEditingImplCopyWith<$Res> {
  __$$SurveyEditingImplCopyWithImpl(
    _$SurveyEditingImpl _value,
    $Res Function(_$SurveyEditingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$SurveyEditingImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as SurveyData,
      ),
    );
  }

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SurveyDataCopyWith<$Res> get data {
    return $SurveyDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$SurveyEditingImpl implements SurveyEditing {
  const _$SurveyEditingImpl(this.data);

  @override
  final SurveyData data;

  @override
  String toString() {
    return 'SurveyState.editing(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyEditingImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyEditingImplCopyWith<_$SurveyEditingImpl> get copyWith =>
      __$$SurveyEditingImplCopyWithImpl<_$SurveyEditingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SurveyData data) editing,
    required TResult Function(SurveyData data) submitting,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return editing(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SurveyData data)? editing,
    TResult? Function(SurveyData data)? submitting,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return editing?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SurveyData data)? editing,
    TResult Function(SurveyData data)? submitting,
    TResult Function()? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (editing != null) {
      return editing(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyLoading value) loading,
    required TResult Function(SurveyEditing value) editing,
    required TResult Function(SurveySubmitting value) submitting,
    required TResult Function(SurveySuccess value) success,
    required TResult Function(SurveyError value) error,
  }) {
    return editing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyLoading value)? loading,
    TResult? Function(SurveyEditing value)? editing,
    TResult? Function(SurveySubmitting value)? submitting,
    TResult? Function(SurveySuccess value)? success,
    TResult? Function(SurveyError value)? error,
  }) {
    return editing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyLoading value)? loading,
    TResult Function(SurveyEditing value)? editing,
    TResult Function(SurveySubmitting value)? submitting,
    TResult Function(SurveySuccess value)? success,
    TResult Function(SurveyError value)? error,
    required TResult orElse(),
  }) {
    if (editing != null) {
      return editing(this);
    }
    return orElse();
  }
}

abstract class SurveyEditing implements SurveyState {
  const factory SurveyEditing(final SurveyData data) = _$SurveyEditingImpl;

  SurveyData get data;

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyEditingImplCopyWith<_$SurveyEditingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SurveySubmittingImplCopyWith<$Res> {
  factory _$$SurveySubmittingImplCopyWith(
    _$SurveySubmittingImpl value,
    $Res Function(_$SurveySubmittingImpl) then,
  ) = __$$SurveySubmittingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SurveyData data});

  $SurveyDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$SurveySubmittingImplCopyWithImpl<$Res>
    extends _$SurveyStateCopyWithImpl<$Res, _$SurveySubmittingImpl>
    implements _$$SurveySubmittingImplCopyWith<$Res> {
  __$$SurveySubmittingImplCopyWithImpl(
    _$SurveySubmittingImpl _value,
    $Res Function(_$SurveySubmittingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$SurveySubmittingImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as SurveyData,
      ),
    );
  }

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SurveyDataCopyWith<$Res> get data {
    return $SurveyDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$SurveySubmittingImpl implements SurveySubmitting {
  const _$SurveySubmittingImpl(this.data);

  @override
  final SurveyData data;

  @override
  String toString() {
    return 'SurveyState.submitting(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveySubmittingImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveySubmittingImplCopyWith<_$SurveySubmittingImpl> get copyWith =>
      __$$SurveySubmittingImplCopyWithImpl<_$SurveySubmittingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SurveyData data) editing,
    required TResult Function(SurveyData data) submitting,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return submitting(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SurveyData data)? editing,
    TResult? Function(SurveyData data)? submitting,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return submitting?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SurveyData data)? editing,
    TResult Function(SurveyData data)? submitting,
    TResult Function()? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (submitting != null) {
      return submitting(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyLoading value) loading,
    required TResult Function(SurveyEditing value) editing,
    required TResult Function(SurveySubmitting value) submitting,
    required TResult Function(SurveySuccess value) success,
    required TResult Function(SurveyError value) error,
  }) {
    return submitting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyLoading value)? loading,
    TResult? Function(SurveyEditing value)? editing,
    TResult? Function(SurveySubmitting value)? submitting,
    TResult? Function(SurveySuccess value)? success,
    TResult? Function(SurveyError value)? error,
  }) {
    return submitting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyLoading value)? loading,
    TResult Function(SurveyEditing value)? editing,
    TResult Function(SurveySubmitting value)? submitting,
    TResult Function(SurveySuccess value)? success,
    TResult Function(SurveyError value)? error,
    required TResult orElse(),
  }) {
    if (submitting != null) {
      return submitting(this);
    }
    return orElse();
  }
}

abstract class SurveySubmitting implements SurveyState {
  const factory SurveySubmitting(final SurveyData data) =
      _$SurveySubmittingImpl;

  SurveyData get data;

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveySubmittingImplCopyWith<_$SurveySubmittingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SurveySuccessImplCopyWith<$Res> {
  factory _$$SurveySuccessImplCopyWith(
    _$SurveySuccessImpl value,
    $Res Function(_$SurveySuccessImpl) then,
  ) = __$$SurveySuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SurveySuccessImplCopyWithImpl<$Res>
    extends _$SurveyStateCopyWithImpl<$Res, _$SurveySuccessImpl>
    implements _$$SurveySuccessImplCopyWith<$Res> {
  __$$SurveySuccessImplCopyWithImpl(
    _$SurveySuccessImpl _value,
    $Res Function(_$SurveySuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SurveySuccessImpl implements SurveySuccess {
  const _$SurveySuccessImpl();

  @override
  String toString() {
    return 'SurveyState.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SurveySuccessImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SurveyData data) editing,
    required TResult Function(SurveyData data) submitting,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SurveyData data)? editing,
    TResult? Function(SurveyData data)? submitting,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SurveyData data)? editing,
    TResult Function(SurveyData data)? submitting,
    TResult Function()? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyLoading value) loading,
    required TResult Function(SurveyEditing value) editing,
    required TResult Function(SurveySubmitting value) submitting,
    required TResult Function(SurveySuccess value) success,
    required TResult Function(SurveyError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyLoading value)? loading,
    TResult? Function(SurveyEditing value)? editing,
    TResult? Function(SurveySubmitting value)? submitting,
    TResult? Function(SurveySuccess value)? success,
    TResult? Function(SurveyError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyLoading value)? loading,
    TResult Function(SurveyEditing value)? editing,
    TResult Function(SurveySubmitting value)? submitting,
    TResult Function(SurveySuccess value)? success,
    TResult Function(SurveyError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SurveySuccess implements SurveyState {
  const factory SurveySuccess() = _$SurveySuccessImpl;
}

/// @nodoc
abstract class _$$SurveyErrorImplCopyWith<$Res> {
  factory _$$SurveyErrorImplCopyWith(
    _$SurveyErrorImpl value,
    $Res Function(_$SurveyErrorImpl) then,
  ) = __$$SurveyErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SurveyErrorImplCopyWithImpl<$Res>
    extends _$SurveyStateCopyWithImpl<$Res, _$SurveyErrorImpl>
    implements _$$SurveyErrorImplCopyWith<$Res> {
  __$$SurveyErrorImplCopyWithImpl(
    _$SurveyErrorImpl _value,
    $Res Function(_$SurveyErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SurveyErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SurveyErrorImpl implements SurveyError {
  const _$SurveyErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SurveyState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyErrorImplCopyWith<_$SurveyErrorImpl> get copyWith =>
      __$$SurveyErrorImplCopyWithImpl<_$SurveyErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SurveyData data) editing,
    required TResult Function(SurveyData data) submitting,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SurveyData data)? editing,
    TResult? Function(SurveyData data)? submitting,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SurveyData data)? editing,
    TResult Function(SurveyData data)? submitting,
    TResult Function()? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SurveyLoading value) loading,
    required TResult Function(SurveyEditing value) editing,
    required TResult Function(SurveySubmitting value) submitting,
    required TResult Function(SurveySuccess value) success,
    required TResult Function(SurveyError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SurveyLoading value)? loading,
    TResult? Function(SurveyEditing value)? editing,
    TResult? Function(SurveySubmitting value)? submitting,
    TResult? Function(SurveySuccess value)? success,
    TResult? Function(SurveyError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SurveyLoading value)? loading,
    TResult Function(SurveyEditing value)? editing,
    TResult Function(SurveySubmitting value)? submitting,
    TResult Function(SurveySuccess value)? success,
    TResult Function(SurveyError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SurveyError implements SurveyState {
  const factory SurveyError(final String message) = _$SurveyErrorImpl;

  String get message;

  /// Create a copy of SurveyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyErrorImplCopyWith<_$SurveyErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
