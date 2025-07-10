import 'package:sqflite/sqflite.dart';
import '../../../../../data/database/database_helper.dart';
import '../../../../../data/models/medication.dart';

class MedicationDao {
  final DatabaseHelper _dbHelper;

  MedicationDao(this._dbHelper);

  Future<int> insertMedication(Medication medication) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.tableMedications,
      medication.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medication>> getMedicationsByDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateString = Medication.dateToString(date);
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableMedications,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [dateString],
      orderBy: '${DatabaseHelper.columnTimestamp} ASC',
    );

    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  Future<void> updateMedication(Medication medication) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableMedications,
      medication.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [medication.id],
    );
  }

  Future<void> deleteMedication(int medicationId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableMedications,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [medicationId],
    );
  }

  Future<List<Medication>> getAllMedications() async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableMedications,
      orderBy: '${DatabaseHelper.columnDate} DESC, ${DatabaseHelper.columnTimestamp} ASC',
    );

    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }
}