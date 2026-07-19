import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance_app.db');

    return await openDatabase(
      path,
      version: 6, // Increment version number if needed
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createFinancialProfileTable(db);
    await _createFinancialAnalysisCacheTable(db);
    // Create transactions table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS transactions (
      id TEXT PRIMARY KEY,
      cash REAL NOT NULL,
      date TEXT NOT NULL,
      note TEXT,
      account TEXT,
      category TEXT,
      typeSpending INTEGER NOT NULL,
      destination TEXT
    )
  ''');

    // Create accounts table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS accounts (
      id TEXT PRIMARY KEY,
      cash REAL NOT NULL,
      icon TEXT NOT NULL,
      title TEXT NOT NULL
    )
  ''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  icon TEXT NOT NULL,
  type INTEGER NOT NULL
)
''');
  }

  /// Runs for existing installs when the schema version increases.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _createFinancialProfileTable(db);
    }
    if (oldVersion < 4) {
      await _addProfileMetaColumns(db);
    }
    if (oldVersion < 5) {
      await _createFinancialAnalysisCacheTable(db);
    }
    if (oldVersion < 6) {
      await db.execute(
        'ALTER TABLE financial_profile ADD COLUMN monthlyExpenseLimit REAL',
      );
    }
  }

  /// Cached AI analysis — a single row keyed by [FinancialAnalysisCache.primaryId].
  ///
  /// [fingerprint] is a hash of the inputs (profile + spending + month) the
  /// analysis was generated from; comparing it against the current inputs lets
  /// us reuse the saved result instead of spending Gemini tokens on unchanged
  /// data.
  Future<void> _createFinancialAnalysisCacheTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS financial_analysis_cache (
      id TEXT PRIMARY KEY,
      fingerprint TEXT NOT NULL,
      analysisJson TEXT NOT NULL,
      updatedAt INTEGER NOT NULL
    )
  ''');
  }

  /// Onboarding survey data — a single row keyed by [FinancialProfile.primaryId].
  Future<void> _createFinancialProfileTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS financial_profile (
      id TEXT PRIMARY KEY,
      goal TEXT,
      currencyCode TEXT NOT NULL DEFAULT 'USD',
      payFrequency TEXT NOT NULL DEFAULT 'monthly',
      salary REAL NOT NULL,
      otherIncome REAL NOT NULL,
      housePayment REAL NOT NULL,
      carPayment REAL NOT NULL,
      utilitiesPayment REAL NOT NULL,
      categoryBudgets TEXT,
      monthlyExpenseLimit REAL
    )
  ''');
  }

  /// v4: goal / currency / pay-frequency added to the onboarding profile.
  Future<void> _addProfileMetaColumns(Database db) async {
    await db.execute('ALTER TABLE financial_profile ADD COLUMN goal TEXT');
    await db.execute(
      "ALTER TABLE financial_profile ADD COLUMN currencyCode TEXT NOT NULL DEFAULT 'USD'",
    );
    await db.execute(
      "ALTER TABLE financial_profile ADD COLUMN payFrequency TEXT NOT NULL DEFAULT 'monthly'",
    );
  }
}
