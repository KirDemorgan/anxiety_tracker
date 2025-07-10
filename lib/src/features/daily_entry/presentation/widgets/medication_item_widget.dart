import 'package:flutter/material.dart';
import '../../../../data/models/medication.dart';

// Виджет для отображения одного элемента записи о лекарстве в списке.
class MedicationItemWidget extends StatelessWidget {
  final Medication medication;

  const MedicationItemWidget({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final timeFormatter = MaterialLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: Colors.teal[50],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: Icon(Icons.medication_outlined, color: Theme.of(context).primaryColorDark),
        title: Text(
          medication.name,
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          'Время: ${timeFormatter.formatTimeOfDay(medication.time, alwaysUse24HourFormat: true)}\nДозировка: ${medication.dosage ?? "не указана"}',
          style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
        ),
        // Можно добавить кнопку для удаления или редактирования
        // trailing: IconButton(icon: Icon(Icons.edit), onPressed: () { /* TODO: Edit medication */ }),
      ),
    );
  }
}

