import '../../../../data/models/daily_mood_entry.dart';

abstract class DailyMoodEntryRepository {
  Future<void> saveDailyMoodEntry(DailyMoodEntry entry);
  Future<DailyMoodEntry?> getDailyMoodEntry(DateTime date);
  Future<List<DailyMoodEntry>> getAllDailyMoodEntries(); // Для сводки
  Future<void> deleteDailyMoodEntry(DateTime date);
}
