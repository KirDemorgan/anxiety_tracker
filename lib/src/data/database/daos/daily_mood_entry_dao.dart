import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/daily_mood_entry.dart';
import 'package:intl/intl.dart';

class DailyMoodEntryDao {
  final DatabaseHelper _dbHelper;

  DailyMoodEntryDao(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.database;

  Future<int> insertOrUpdateDailyMoodEntry(DailyMoodEntry entry) async {
    final dbClient = await _db;
    final existingEntry = await getDailyMoodEntryByDate(entry.date);
    if (existingEntry != null) {
      return await dbClient.update(
        DatabaseHelper.tableDailyEntries,
        entry.toMap()..remove('id'),
        where: '${DatabaseHelper.columnDate} = ?',
        whereArgs: [DateFormat('yyyy-MM-dd').format(entry.date)],
      );
    } else {
      return await dbClient.insert(
        DatabaseHelper.tableDailyEntries,
        entry.toMap()..remove('id'),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
  
  Future<DailyMoodEntry?> getDailyMoodEntryByDate(DateTime date) async {
    final dbClient = await _db;
    final String dateString = DateFormat('yyyy-MM-dd').format(date);
    final List<Map<String, dynamic>> maps = await dbClient.query(
      DatabaseHelper.tableDailyEntries,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
    );

    if (maps.isNotEmpty) {
      return DailyMoodEntry.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DailyMoodEntry>> getAllDailyMoodEntries() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(DatabaseHelper.tableDailyEntries);
    return List.generate(maps.length, (i) {
      return DailyMoodEntry.fromMap(maps[i]);
    });
  }
  
  Future<int> deleteDailyMoodEntry(DateTime date) async {
    final dbClient = await _db;
    final String dateString = DateFormat('yyyy-MM-dd').format(date);
    return await dbClient.delete(
      DatabaseHelper.tableDailyEntries,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
    );
  }
}
