import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Note {
  static String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  final int? id;
  final DateTime date;
  final TimeOfDay time;
  final String text;

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

  Map<String, dynamic> toMap() {
    final DateTime fullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return {
      'id': id,
      'date': Note.dateToString(date),
      'timestamp': fullDateTime.millisecondsSinceEpoch,
      'text': text,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    final DateTime fullDateTime = DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int);
    return Note(
      id: map['id'] as int?,
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
