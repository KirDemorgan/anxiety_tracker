import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Medication {
  static String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  final int? id;
  final DateTime date;
  final TimeOfDay time;
  final String name;
  final String? dosage;

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
    bool setDosageNull = false,
  }) {
    return Medication(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      name: name ?? this.name,
      dosage: setDosageNull ? null : (dosage ?? this.dosage),
    );
  }

  Map<String, dynamic> toMap() {
    final DateTime fullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return {
      'id': id,
      'date': Medication.dateToString(date),
      'timestamp': fullDateTime.millisecondsSinceEpoch,
      'name': name,
      'dosage': dosage,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    final DateTime fullDateTime = DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int);
    return Medication(
      id: map['id'] as int?,
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
