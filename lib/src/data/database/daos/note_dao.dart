import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/note.dart';
import 'package:intl/intl.dart';

class NoteDao {
  final DatabaseHelper _dbHelper;

  NoteDao(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.database;

  // Вставить новую заметку
  Future<int> insertNote(Note note) async {
    final dbClient = await _db;
    return await dbClient.insert(
      DatabaseHelper.tableNotes,
      note.toMap()..remove('id'), // id будет автоинкрементирован
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Получить все заметки для определенной даты
  Future<List<Note>> getNotesByDate(DateTime date) async {
    final dbClient = await _db;
    final String dateString = DateFormat('yyyy-MM-dd').format(date);
    final List<Map<String, dynamic>> maps = await dbClient.query(
      DatabaseHelper.tableNotes,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
      orderBy: '${DatabaseHelper.columnTimestamp} ASC', // Сортируем по времени
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Обновить заметку
  Future<int> updateNote(Note note) async {
    final dbClient = await _db;
    return await dbClient.update(
      DatabaseHelper.tableNotes,
      note.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [note.id],
    );
  }

  // Удалить заметку по ID
  Future<int> deleteNote(int id) async {
    final dbClient = await _db;
    return await dbClient.delete(
      DatabaseHelper.tableNotes,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }

  // Получить все заметки (для отладки или других нужд)
  Future<List<Note>> getAllNotes() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(DatabaseHelper.tableNotes);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}
