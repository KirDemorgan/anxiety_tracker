import 'package:sqflite/sqflite.dart';
import '../../../../../data/database/database_helper.dart';
import '../../../../../data/models/note.dart';

class NoteDao {
  final DatabaseHelper _dbHelper;

  NoteDao(this._dbHelper);

  Future<int> insertNote(Note note) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.tableNotes,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotesByDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateString = Note.dateToString(date);
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableNotes,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
      orderBy: '${DatabaseHelper.columnTimestamp} ASC',
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<void> updateNote(Note note) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableNotes,
      note.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int noteId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableNotes,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [noteId],
    );
  }

  Future<List<Note>> getAllNotes() async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableNotes,
      orderBy: '${DatabaseHelper.columnDate} DESC, ${DatabaseHelper.columnTimestamp} ASC',
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}