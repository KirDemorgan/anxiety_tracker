import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/medication.dart';
import 'package:intl/intl.dart';

class MedicationDao {
  final DatabaseHelper _dbHelper;

  MedicationDao(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.database;

  Future<int> insertMedication(Medication medication) async {
    final dbClient = await _db;
    return await dbClient.insert(
      DatabaseHelper.tableMedications,
      medication.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medication>> getMedicationsByDate(DateTime date) async {
    final dbClient = await _db;
    final String dateString = DateFormat('yyyy-MM-dd').format(date);
    final List<Map<String, dynamic>> maps = await dbClient.query(
      DatabaseHelper.tableMedications,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
      orderBy: '${DatabaseHelper.columnTimestamp} ASC',
    );

    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  Future<int> updateMedication(Medication medication) async {
    final dbClient = await _db;
    return await dbClient.update(
      DatabaseHelper.tableMedications,
      medication.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [medication.id],
    );
  }

  Future<int> deleteMedication(int id) async {
    final dbClient = await _db;
    return await dbClient.delete(
      DatabaseHelper.tableMedications,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }
  
  Future<List<Medication>> getAllMedications() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(DatabaseHelper.tableMedications);
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }
}
