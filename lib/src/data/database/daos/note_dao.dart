import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/note.dart';
import 'package:intl/intl.dart';

class NoteDao {
  final DatabaseHelper _dbHelper;

  NoteDao(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.database;

  Future<int> insertNote(Note note) async {
    final dbClient = await _db;
    return await dbClient.insert(
      DatabaseHelper.tableNotes,
      note.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotesByDate(DateTime date) async {
    final dbClient = await _db;
    final String dateString = DateFormat('yyyy-MM-dd').format(date);
    final List<Map<String, dynamic>> maps = await dbClient.query(
      DatabaseHelper.tableNotes,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
      orderBy: '${DatabaseHelper.columnTimestamp} ASC',
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> updateNote(Note note) async {
    final dbClient = await _db;
    return await dbClient.update(
      DatabaseHelper.tableNotes,
      note.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final dbClient = await _db;
    return await dbClient.delete(
      DatabaseHelper.tableNotes,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Note>> getAllNotes() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(DatabaseHelper.tableNotes);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}
