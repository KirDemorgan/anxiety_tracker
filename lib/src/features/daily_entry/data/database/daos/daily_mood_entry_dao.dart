import 'package:sqflite/sqflite.dart';
import '../../../../../data/database/database_helper.dart';
import '../../../../../data/models/daily_mood_entry.dart';

class DailyMoodEntryDao {
  final DatabaseHelper _dbHelper;

  DailyMoodEntryDao(this._dbHelper);

  Future<void> insertOrUpdateDailyMoodEntry(DailyMoodEntry entry) async {
    final db = await _dbHelper.database;
    
    // Проверяем, существует ли запись для этой даты
    final existingEntry = await getDailyMoodEntryByDate(entry.date);
    
    if (existingEntry == null) {
      // Вставляем новую запись
      await db.insert(
        DatabaseHelper.tableDailyEntries,
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Обновляем существующую запись
      await db.update(
        DatabaseHelper.tableDailyEntries,
        entry.toMap(),
        where: '${DatabaseHelper.columnDate} = ?',
        whereArgs: [DailyMoodEntry.dateToString(entry.date)],
      );
    }
  }

  Future<DailyMoodEntry?> getDailyMoodEntryByDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateString = DailyMoodEntry.dateToString(date);
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableDailyEntries,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
    );

    if (maps.isEmpty) {
      return null;
    }

    return DailyMoodEntry.fromMap(maps.first);
  }

  Future<List<DailyMoodEntry>> getAllDailyMoodEntries() async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableDailyEntries,
      orderBy: '${DatabaseHelper.columnDate} DESC',
    );

    return List.generate(maps.length, (i) {
      return DailyMoodEntry.fromMap(maps[i]);
    });
  }

  Future<void> deleteDailyMoodEntry(DateTime date) async {
    final db = await _dbHelper.database;
    final dateString = DailyMoodEntry.dateToString(date);
    
    await db.delete(
      DatabaseHelper.tableDailyEntries,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
    );
  }
}