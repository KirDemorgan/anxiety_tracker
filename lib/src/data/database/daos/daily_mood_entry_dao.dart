import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/daily_mood_entry.dart';
import 'package:intl/intl.dart';

class DailyMoodEntryDao {
  final DatabaseHelper _dbHelper;

  DailyMoodEntryDao(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.database;

  // Создать или обновить запись о настроении
  // sqflite's insert with conflictAlgorithm.replace handles UPSERT.
  Future<int> insertOrUpdateDailyMoodEntry(DailyMoodEntry entry) async {
    final dbClient = await _db;
    // Проверяем, есть ли запись для этой даты
    final existingEntry = await getDailyMoodEntryByDate(entry.date);
    if (existingEntry != null) {
      // Обновляем существующую запись
      return await dbClient.update(
        DatabaseHelper.tableDailyEntries,
        entry.toMap()..remove('id'), // id не нужен для WHERE clause по дате
        where: '${DatabaseHelper.columnDate} = ?',
        whereArgs: [DateFormat('yyyy-MM-dd').format(entry.date)],
      );
    } else {
      // Вставляем новую запись
      return await dbClient.insert(
        DatabaseHelper.tableDailyEntries,
        entry.toMap()..remove('id'), // id будет автоинкрементирован
        conflictAlgorithm: ConflictAlgorithm.replace, // На случай если дата все же как-то продублируется (хотя UNIQUE)
      );
    }
  }
  
  // Получить запись о настроении по дате
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

  // Получить все записи о настроении (может понадобиться для сводки)
  Future<List<DailyMoodEntry>> getAllDailyMoodEntries() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(DatabaseHelper.tableDailyEntries);
    return List.generate(maps.length, (i) {
      return DailyMoodEntry.fromMap(maps[i]);
    });
  }
  
  // Удалить запись (если потребуется)
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
