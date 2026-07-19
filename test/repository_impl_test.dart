import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/data/repository/repository_impl.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/type_spending.dart';
import 'package:finance_app/domain/models/account.dart';
import 'package:finance_app/domain/models/category_budget_progress.dart';
import 'package:finance_app/domain/models/financial_analysis.dart';
import 'package:finance_app/domain/models/financial_profile.dart';
import 'package:finance_app/data/data_source/local/account_dao.dart';
import 'package:finance_app/data/data_source/local/category_dao.dart';
import 'package:finance_app/data/data_source/local/financial_analysis_dao.dart';
import 'package:finance_app/data/data_source/local/financial_profile_dao.dart';
import 'package:finance_app/data/data_source/local/transaction_dao.dart';
import 'package:finance_app/data/data_source/remote/gemini_remote_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'repository_impl_test.mocks.dart';

@GenerateMocks([
  AccountDao,
  CategoryDao,
  TransactionDao,
  FinancialProfileDao,
  GeminiRemoteDataSource,
  FinancialAnalysisDao,
])
void main() {
  late RepositoryImpl repository;
  late MockAccountDao mockAccountDao;
  late MockCategoryDao mockCategoryDao;
  late MockTransactionDao mockTransactionDao;
  late MockFinancialProfileDao mockFinancialProfileDao;
  late MockGeminiRemoteDataSource mockGeminiRemoteDataSource;
  late MockFinancialAnalysisDao mockFinancialAnalysisDao;

  // Mock data
  final mockAccounts = [
    Account(cash: 1000.0, icon: 'card', title: 'Card'),
    Account(cash: 500.0, icon: 'cash', title: 'Cash'),
  ];

  final mockTransactions = [
    Transaction(
      cash: 100.0,
      date: DateTime.now(),
      note: 'Test expense 1',
      typeSpending: TypeSpending.expense,
      account: mockAccounts[0],
    ),
    Transaction(
      cash: 200.0,
      date: DateTime.now(),
      note: 'Test expense 2',
      typeSpending: TypeSpending.expense,
      account: mockAccounts[1],
    ),
    Transaction(
      cash: 300.0,
      date: DateTime.now(),
      note: 'Test income',
      typeSpending: TypeSpending.income,
      account: mockAccounts[0],
    ),
  ];

  setUp(() {
    mockAccountDao = MockAccountDao();
    mockCategoryDao = MockCategoryDao();
    mockTransactionDao = MockTransactionDao();
    mockFinancialProfileDao = MockFinancialProfileDao();
    mockGeminiRemoteDataSource = MockGeminiRemoteDataSource();
    mockFinancialAnalysisDao = MockFinancialAnalysisDao();
    repository = RepositoryImpl(
      mockCategoryDao,
      mockAccountDao,
      mockTransactionDao,
      mockFinancialProfileDao,
      mockGeminiRemoteDataSource,
      mockFinancialAnalysisDao,
    );

    when(mockAccountDao.getAccounts()).thenAnswer((_) async => mockAccounts);
    when(
      mockTransactionDao.getTransactions(any),
    ).thenAnswer((_) async => mockTransactions);
    // Default: no cache and a no-op save, so analysis tests hit Gemini.
    when(mockFinancialAnalysisDao.get()).thenAnswer((_) async => null);
    when(mockFinancialAnalysisDao.save(any, any)).thenAnswer((_) async => 1);
  });

  group('expenseAmount', () {
    test('should return 0 when transactions list is empty', () async {
      // Arrange
      final transactions = <Transaction>[];

      // Act
      final result = await repository.expenseAmount(transactions);

      // Assert
      expect(result, 0.0);
    });

    test('should calculate total expense amount correctly', () async {
      // Arrange
      final transactions = mockTransactions;

      // Act
      final result = await repository.expenseAmount(transactions);

      // Assert
      expect(result, 300.0); // Only expenses (100 + 200) should be counted
    });
  });

  group('loadAccountData', () {
    test('should return default accounts when no accounts exist', () async {
      when(mockAccountDao.getAccounts()).thenAnswer((_) async => []);

      final result = await repository.loadAccountData();

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (accounts) {
        expect(accounts.length, 3); // Default accounts count
        expect(accounts[0].title, 'Card');
        expect(accounts[1].title, 'Cash');
        expect(accounts[2].title, 'Saving');
      });
    });

    test('should return existing accounts when accounts exist', () async {
      final result = await repository.loadAccountData();

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (accounts) {
        expect(accounts.length, mockAccounts.length);
        expect(accounts[0].title, mockAccounts[0].title);
        expect(accounts[1].title, mockAccounts[1].title);
      });
    });
  });

  group('getFinancialAnalysis', () {
    final args = FinancialAnalysisArguments(
      profile: FinancialProfile(
        salary: 3000,
        otherIncome: 0,
        housePayment: 1000,
        carPayment: 200,
        utilitiesPayment: 150,
      ),
      totalExpense: 1350,
      totalIncome: 3000,
      month: DateTime(2026, 7),
    );

    test('returns the analysis on success and caches it', () async {
      const analysis = FinancialAnalysis(summary: 'ok', recommendations: []);
      when(
        mockGeminiRemoteDataSource.getAnalysis(any),
      ).thenAnswer((_) async => analysis);

      final result = await repository.getFinancialAnalysis(args);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not return failure'),
        (value) => expect(value.summary, 'ok'),
      );
      verify(
        mockFinancialAnalysisDao.save(analysis, args.fingerprint),
      ).called(1);
    });

    test(
      'reuses the cache and skips Gemini when the fingerprint matches',
      () async {
        const cachedAnalysis = FinancialAnalysis(
          summary: 'cached',
          recommendations: [],
        );
        when(mockFinancialAnalysisDao.get()).thenAnswer(
          (_) async => CachedFinancialAnalysis(
            analysis: cachedAnalysis,
            fingerprint: args.fingerprint,
            updatedAt: DateTime.now(),
          ),
        );

        final result = await repository.getFinancialAnalysis(args);

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should not return failure'),
          (value) => expect(value.summary, 'cached'),
        );
        verifyNever(mockGeminiRemoteDataSource.getAnalysis(any));
      },
    );

    test(
      'forceRefresh calls Gemini even when a matching cache exists',
      () async {
        const cachedAnalysis = FinancialAnalysis(
          summary: 'cached',
          recommendations: [],
        );
        const freshAnalysis = FinancialAnalysis(
          summary: 'fresh',
          recommendations: [],
        );
        when(mockFinancialAnalysisDao.get()).thenAnswer(
          (_) async => CachedFinancialAnalysis(
            analysis: cachedAnalysis,
            fingerprint: args.fingerprint,
            updatedAt: DateTime.now(),
          ),
        );
        when(
          mockGeminiRemoteDataSource.getAnalysis(any),
        ).thenAnswer((_) async => freshAnalysis);

        final forced = FinancialAnalysisArguments(
          profile: args.profile,
          categoryBudgets: args.categoryBudgets,
          totalExpense: args.totalExpense,
          totalIncome: args.totalIncome,
          month: args.month,
          forceRefresh: true,
        );
        final result = await repository.getFinancialAnalysis(forced);

        result.fold(
          (_) => fail('Should not return failure'),
          (value) => expect(value.summary, 'fresh'),
        );
        verify(mockGeminiRemoteDataSource.getAnalysis(any)).called(1);
      },
    );

    test('falls back to cached analysis when Gemini fails', () async {
      const cachedAnalysis = FinancialAnalysis(
        summary: 'stale',
        recommendations: [],
      );
      when(mockFinancialAnalysisDao.get()).thenAnswer(
        (_) async => CachedFinancialAnalysis(
          analysis: cachedAnalysis,
          fingerprint: 'different-fingerprint',
          updatedAt: DateTime.now(),
        ),
      );
      when(
        mockGeminiRemoteDataSource.getAnalysis(any),
      ).thenThrow(GeminiException(GeminiErrorType.offline, 'no network'));

      final result = await repository.getFinancialAnalysis(args);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should fall back to cache'),
        (value) => expect(value.summary, 'stale'),
      );
    });

    test('maps a rate-limit GeminiException to a 429 Failure', () async {
      when(mockGeminiRemoteDataSource.getAnalysis(any)).thenThrow(
        GeminiException(GeminiErrorType.rateLimited, 'quota exceeded'),
      );

      final result = await repository.getFinancialAnalysis(args);

      expect(result.isLeft(), true);
      result.fold((failure) => expect(failure.code, 429), (_) => fail('nope'));
    });

    test('maps a missing-key GeminiException to a typed Failure', () async {
      when(
        mockGeminiRemoteDataSource.getAnalysis(any),
      ).thenThrow(GeminiException(GeminiErrorType.missingApiKey, 'no key'));

      final result = await repository.getFinancialAnalysis(args);

      expect(result.isLeft(), true);
      result.fold((failure) => expect(failure.code, 1001), (_) => fail('nope'));
    });
  });

  group('CategoryBudgetProgress', () {
    CategoryBudgetProgress row(double spent, double max) =>
        CategoryBudgetProgress(
          categoryId: 'id',
          title: 'Food',
          icon: 'foods_icon',
          spent: spent,
          max: max,
        );

    test('detects over-budget and computes the ratio', () {
      final over = row(600, 500);
      expect(over.hasBudget, true);
      expect(over.isOverBudget, true);
      expect(over.ratio, closeTo(1.2, 0.0001));
    });

    test('under budget is not flagged', () {
      final under = row(400, 500);
      expect(under.isOverBudget, false);
      expect(under.ratio, closeTo(0.8, 0.0001));
    });

    test('no budget means no ratio and never over budget', () {
      final none = row(400, 0);
      expect(none.hasBudget, false);
      expect(none.isOverBudget, false);
      expect(none.ratio, 0);
    });
  });

  group('FinancialAnalysis.fromJson', () {
    test('parses summary, score and recommendations', () {
      final analysis = FinancialAnalysis.fromJson({
        'summary': 'Spending is under control.',
        'healthScore': 82,
        'recommendations': [
          {
            'title': 'Great job',
            'detail': 'You are under budget.',
            'severity': 'positive',
          },
        ],
      });

      expect(analysis.summary, 'Spending is under control.');
      expect(analysis.healthScore, 82);
      expect(
        analysis.recommendations.single.severity,
        RecommendationSeverity.positive,
      );
    });

    test('defaults unknown severity to info and tolerates missing fields', () {
      final analysis = FinancialAnalysis.fromJson({
        'recommendations': [
          {'title': 'x', 'detail': 'y', 'severity': 'bogus'},
        ],
      });

      expect(analysis.summary, '');
      expect(analysis.healthScore, isNull);
      expect(
        analysis.recommendations.single.severity,
        RecommendationSeverity.info,
      );
    });
  });
}
