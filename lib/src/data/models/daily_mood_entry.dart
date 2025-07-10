import 'package:intl/intl.dart';

class DailyMoodEntry {
  static String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  final int? id;
  final DateTime date;
  final int? morningMood;
  final int? dayMood;
  final int? eveningMood;

  DailyMoodEntry({
    this.id,
    required this.date,
    this.morningMood,
    this.dayMood,
    this.eveningMood,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': DailyMoodEntry.dateToString(date),
      'morning_mood': morningMood,
      'day_mood': dayMood,
      'evening_mood': eveningMood,
    };
  }

  factory DailyMoodEntry.fromMap(Map<String, dynamic> map) {
    return DailyMoodEntry(
      id: map['id'] as int?,
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
