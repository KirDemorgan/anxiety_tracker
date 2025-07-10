import '../../../../data/database/daos/medication_dao.dart';
import '../../../../data/models/medication.dart';
import '../../domain/repositories/medication_repository.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationDao _dao;

  MedicationRepositoryImpl(this._dao);

  @override
  Future<int> addMedication(Medication medication) async {
    try {
      return await _dao.insertMedication(medication);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Medication>> getMedicationsForDate(DateTime date) async {
    try {
      return await _dao.getMedicationsByDate(date);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    try {
      await _dao.updateMedication(medication);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMedication(int medicationId) async {
    try {
      await _dao.deleteMedication(medicationId);
    } catch (e) {
      rethrow;
    }
  }
}
