import 'dart:convert';

import 'package:finance_app/data/data_source/local/database_helper.dart';
import 'package:finance_app/domain/models/financial_analysis.dart';
import 'package:sqflite/sqflite.dart';

/// Persists AI analyses, one cached row per month (row id = month key, e.g.
/// `2026-07`). Keeping a row per month means switching months reuses each
/// month's result instead of evicting a single shared slot — the main token
/// optimisation. Old rows are pruned so the table can't grow unbounded.
class FinancialAnalysisDao {
  final dbHelper = DatabaseHelper.instance;

  /// How many months of cached analyses to retain (oldest are pruned).
  static const int _maxRows = 24;

  Future<int> save(
    String monthKey,
    FinancialAnalysis analysis,
    String fingerprint,
  ) async {
    final db = await dbHelper.database;
    final result = await db.insert('financial_analysis_cache', {
      'id': monthKey,
      'fingerprint': fingerprint,
      'analysisJson': jsonEncode(analysis.toJson()),
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await _prune(db);
    return result;
  }

  /// Returns the cached analysis for [monthKey], or null if none is stored or
  /// the payload is unreadable.
  Future<CachedFinancialAnalysis?> getByMonth(String monthKey) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'financial_analysis_cache',
      where: 'id = ?',
      whereArgs: [monthKey],
      limit: 1,
    );
    if (rows.isEmpty) return null;

    final row = rows.first;
    try {
      final decoded =
          jsonDecode(row['analysisJson'] as String) as Map<String, dynamic>;
      return CachedFinancialAnalysis(
        analysis: FinancialAnalysis.fromJson(decoded),
        fingerprint: row['fingerprint'] as String,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updatedAt'] as int),
      );
    } catch (_) {
      // Corrupt/legacy payload — treat as no cache so we regenerate.
      return null;
    }
  }

  /// Keeps only the [_maxRows] most-recently-updated months.
  Future<void> _prune(Database db) async {
    final rows = await db.query(
      'financial_analysis_cache',
      columns: ['id'],
      orderBy: 'updatedAt DESC',
    );
    if (rows.length <= _maxRows) return;
    for (final row in rows.sublist(_maxRows)) {
      await db.delete(
        'financial_analysis_cache',
        where: 'id = ?',
        whereArgs: [row['id']],
      );
    }
  }
}
