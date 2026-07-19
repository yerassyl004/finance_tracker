import 'package:finance_app/data/data_source/local/database_helper.dart';
import 'package:finance_app/domain/models/financial_profile.dart';
import 'package:sqflite/sqflite.dart';

class FinancialProfileDao {
  final dbHelper = DatabaseHelper.instance;

  /// Insert or replace the single financial profile row.
  Future<int> saveProfile(FinancialProfile profile) async {
    final db = await dbHelper.database;
    return await db.insert(
      'financial_profile',
      profile.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns the stored profile, or null if the survey was never completed.
  Future<FinancialProfile?> getProfile() async {
    final db = await dbHelper.database;
    final result = await db.query(
      'financial_profile',
      where: 'id = ?',
      whereArgs: [FinancialProfile.primaryId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }
    return FinancialProfile.fromJson(result.first);
  }
}
