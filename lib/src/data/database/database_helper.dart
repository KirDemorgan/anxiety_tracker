import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "app_database.db";
  static const _databaseVersion = 1;

  // Таблицы
  static const tableDailyEntries = 'daily_entries';
  static const tableNotes = 'notes';
  static const tableMedications = 'medications';

  // Поля таблицы daily_entries
  static const columnId = 'id';
  static const columnDate = 'date';
  static const columnMorningMood = 'morning_mood';
  static const columnDayMood = 'day_mood';
  static const columnEveningMood = 'evening_mood';

  // Поля таблицы notes
  // columnId, columnDate уже есть
  static const columnTimestamp = 'timestamp';
  static const columnText = 'text';

  // Поля таблицы medications
  // columnId, columnDate, columnTimestamp уже есть
  static const columnName = 'name';
  static const columnDosage = 'dosage';


  // Синглтон
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Инициализация БД
  _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL для создания таблиц
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableDailyEntries (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT UNIQUE NOT NULL,
        $columnMorningMood INTEGER NULL,
        $columnDayMood INTEGER NULL,
        $columnEveningMood INTEGER NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableNotes (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT NOT NULL,
        $columnTimestamp INTEGER NOT NULL,
        $columnText TEXT NOT NULL
      )
      ''');
    await db.execute('CREATE INDEX idx_notes_date ON $tableNotes($columnDate)');

    await db.execute('''
      CREATE TABLE $tableMedications (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT NOT NULL,
        $columnTimestamp INTEGER NOT NULL,
        $columnName TEXT NOT NULL,
        $columnDosage TEXT NULL
      )
      ''');
    await db.execute('CREATE INDEX idx_medications_date ON $tableMedications($columnDate)');
  }

  // Вспомогательные методы для CRUD операций будут в DAO
}
