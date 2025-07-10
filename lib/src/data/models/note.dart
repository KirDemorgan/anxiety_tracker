import 'package:flutter/material.dart'; // Для TimeOfDay
import 'package:intl/intl.dart';

// Модель данных для пользовательских заметок.
class Note {
  // Статический метод для форматирования даты в строку
  static String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  final int? id; // Уникальный идентификатор из БД
  final DateTime date; // Дата заметки (только день, нормализованный к полуночи)
  final TimeOfDay time; // Время заметки
  final String text; // Содержание заметки

  Note({
    this.id,
    required this.date,
    required this.time,
    required this.text,
  });

   Note copyWith({
    int? id,
    DateTime? date,
    TimeOfDay? time,
    String? text,
  }) {
    return Note(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      text: text ?? this.text,
    );
  }

  // Конвертация в Map для сохранения в БД
  Map<String, dynamic> toMap() {
    // Комбинируем дату и время в один DateTime объект для получения timestamp
    final DateTime fullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return {
      'id': id,
      'date': Note.dateToString(date), // Храним дату как строку YYYY-MM-DD для индексации
      'timestamp': fullDateTime.millisecondsSinceEpoch, // Храним полное время как timestamp
      'text': text,
    };
  }

  // Конвертация из Map (полученного из БД) в объект Note
  factory Note.fromMap(Map<String, dynamic> map) {
    final DateTime fullDateTime = DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int);
    return Note(
      id: map['id'] as int?,
      // Date 'date' из БД (YYYY-MM-DD) используется для удобства запросов,
      // но основная дата/время восстанавливается из timestamp.
      date: DateTime(fullDateTime.year, fullDateTime.month, fullDateTime.day),
      time: TimeOfDay.fromDateTime(fullDateTime),
      text: map['text'] as String,
    );
  }

   @override
  String toString() {
    return 'Note(id: $id, date: $date, time: $time, text: "$text")';
  }
}
