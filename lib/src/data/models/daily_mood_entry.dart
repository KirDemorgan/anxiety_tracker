import 'package:intl/intl.dart';

// Модель данных для ежедневных записей о настроении.
class DailyMoodEntry {
  // Статический метод для форматирования даты в строку
  static String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  final int? id; // Уникальный идентификатор из БД (auto-increment)
  final DateTime date; // Дата записи
  final int? morningMood; // Утреннее настроение (1-10)
  final int? dayMood; // Дневное настроение (1-10)
  final int? eveningMood; // Вечернее настроение (1-10)

  DailyMoodEntry({
    this.id,
    required this.date,
    this.morningMood,
    this.dayMood,
    this.eveningMood,
  });

  // Создает копию объекта с возможностью изменения некоторых полей
  DailyMoodEntry copyWith({
    int? id,
    DateTime? date,
    int? morningMood,
    int? dayMood,
    int? eveningMood,
  }) {
    return DailyMoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      morningMood: morningMood ?? this.morningMood,
      dayMood: dayMood ?? this.dayMood,
      eveningMood: eveningMood ?? this.eveningMood,
    );
  }

  // Конвертация в Map для сохранения в БД
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': DailyMoodEntry.dateToString(date), // Храним дату как строку YYYY-MM-DD
      'morning_mood': morningMood,
      'day_mood': dayMood,
      'evening_mood': eveningMood,
    };
  }

  // Конвертация из Map (полученного из БД) в объект DailyMoodEntry
  factory DailyMoodEntry.fromMap(Map<String, dynamic> map) {
    return DailyMoodEntry(
      id: map['id'] as int?,
      // Парсим строку даты обратно в DateTime. 
      // Убедитесь, что 'date' всегда присутствует и корректно отформатирована.
      date: DateFormat('yyyy-MM-dd').parse(map['date'] as String),
      morningMood: map['morning_mood'] as int?,
      dayMood: map['day_mood'] as int?,
      eveningMood: map['evening_mood'] as int?,
    );
  }

  @override
  String toString() {
    return 'DailyMoodEntry(id: $id, date: $date, morning: $morningMood, day: $dayMood, evening: $eveningMood)';
  }
}
