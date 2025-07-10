import 'package:flutter/material.dart'; // Для TimeOfDay
import 'package:intl/intl.dart';

// Модель данных для записей о приеме лекарств.
class Medication {
  // Статический метод для форматирования даты в строку
  static String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  final int? id; // Уникальный идентификатор из БД
  final DateTime date; // Дата приема (только день, нормализованный к полуночи)
  final TimeOfDay time; // Время приема
  final String name; // Название лекарства
  final String? dosage; // Дозировка (опционально)

  Medication({
    this.id,
    required this.date,
    required this.time,
    required this.name,
    this.dosage,
  });

  Medication copyWith({
    int? id,
    DateTime? date,
    TimeOfDay? time,
    String? name,
    String? dosage,
    bool setDosageNull = false, // Флаг для явного обнуления dosage
  }) {
    return Medication(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      name: name ?? this.name,
      dosage: setDosageNull ? null : (dosage ?? this.dosage),
    );
  }

  // Конвертация в Map для сохранения в БД
  Map<String, dynamic> toMap() {
    // Комбинируем дату и время в один DateTime объект для получения timestamp
    final DateTime fullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return {
      'id': id,
      'date': Medication.dateToString(date), // Храним дату как строку YYYY-MM-DD для индексации
      'timestamp': fullDateTime.millisecondsSinceEpoch, // Храним полное время как timestamp
      'name': name,
      'dosage': dosage,
    };
  }

  // Конвертация из Map (полученного из БД) в объект Medication
  factory Medication.fromMap(Map<String, dynamic> map) {
    final DateTime fullDateTime = DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int);
    return Medication(
      id: map['id'] as int?,
      // Date 'date' из БД (YYYY-MM-DD) используется для удобства запросов,
      // но основная дата/время восстанавливается из timestamp.
      // Убедимся, что 'date' часть модели соответствует timestamp.
      date: DateTime(fullDateTime.year, fullDateTime.month, fullDateTime.day),
      time: TimeOfDay.fromDateTime(fullDateTime),
      name: map['name'] as String,
      dosage: map['dosage'] as String?,
    );
  }

   @override
  String toString() {
    return 'Medication(id: $id, date: $date, time: $time, name: $name, dosage: $dosage)';
  }
}
