import '../../../../data/database/daos/daily_mood_entry_dao.dart';
import '../../../../data/models/daily_mood_entry.dart';
import '../../domain/repositories/daily_mood_entry_repository.dart';

class DailyMoodEntryRepositoryImpl implements DailyMoodEntryRepository {
  final DailyMoodEntryDao _dao;

  DailyMoodEntryRepositoryImpl(this._dao);

  @override
  Future<void> saveDailyMoodEntry(DailyMoodEntry entry) async {
    try {
      await _dao.insertOrUpdateDailyMoodEntry(entry);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DailyMoodEntry?> getDailyMoodEntry(DateTime date) async {
    try {
      return await _dao.getDailyMoodEntryByDate(date);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<DailyMoodEntry>> getAllDailyMoodEntries() async {
    try {
      return await _dao.getAllDailyMoodEntries();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> deleteDailyMoodEntry(DateTime date) async {
    try {
      await _dao.deleteDailyMoodEntry(date);
    } catch (e) {
      rethrow;
    }
  }
}
