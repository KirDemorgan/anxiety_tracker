import '../../../../data/models/medication.dart';

abstract class MedicationRepository {
  Future<int> addMedication(Medication medication);
  Future<List<Medication>> getMedicationsForDate(DateTime date);
  Future<void> updateMedication(Medication medication);
  Future<void> deleteMedication(int medicationId);
}
