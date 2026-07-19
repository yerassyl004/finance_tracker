import 'dart:convert';

import 'package:finance_app/data/data_source/local/database_helper.dart';
import 'package:finance_app/domain/models/financial_analysis.dart';
import 'package:sqflite/sqflite.dart';

/// Persists the single cached AI analysis row so results survive app restarts
/// and can be reused when the inputs haven't changed (see
/// [FinancialAnalysisArguments.fingerprint]).
class FinancialAnalysisDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> save(FinancialAnalysis analysis, String fingerprint) async {
    final db = await dbHelper.database;
    return db.insert('financial_analysis_cache', {
      'id': CachedFinancialAnalysis.primaryId,
      'fingerprint': fingerprint,
      'analysisJson': jsonEncode(analysis.toJson()),
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Returns the cached analysis, or null if nothing has been saved yet or the
  /// stored payload is unreadable.
  Future<CachedFinancialAnalysis?> get() async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'financial_analysis_cache',
      where: 'id = ?',
      whereArgs: [CachedFinancialAnalysis.primaryId],
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
}
