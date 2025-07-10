import 'package:flutter/material.dart';
import '../../../../data/models/medication.dart';

// Форма для добавления записи о приеме лекарства.
class MedicationEntryFormWidget extends StatefulWidget {
  final DateTime selectedDate; // Для привязки лекарства к дате
  final Function(Medication) onSave;

  const MedicationEntryFormWidget({
    super.key,
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<MedicationEntryFormWidget> createState() => _MedicationEntryFormWidgetState();
}

class _MedicationEntryFormWidgetState extends State<MedicationEntryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  TimeOfDay? _selectedTime;

 @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now(); // Устанавливаем текущее время по умолчанию
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
       builder: (BuildContext context, Widget? child) { // Для русификации кнопок
        return Localizations.override(
          context: context,
          locale: const Locale('ru', 'RU'),
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
       if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, выберите время приема лекарства.')),
        );
        return;
      }
      // ID будет присвоен базой данных, поэтому здесь не указываем.
      // selectedDate уже содержит только дату (полночь).
      final newMedication = Medication(
        date: widget.selectedDate, // Это DateTime с временем 00:00:00
        time: _selectedTime!,
        name: _nameController.text,
        dosage: _dosageController.text.isNotEmpty ? _dosageController.text : null,
      );
      widget.onSave(newMedication);
      _nameController.clear();
      _dosageController.clear();
      // Оставляем время для удобства добавления следующего лекарства
      // setState(() { _selectedTime = TimeOfDay.now(); }); 
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeFormatter = MaterialLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Название лекарства',
              hintText: 'Например, Атаракс',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите название лекарства.';
              }
              return null;
            },
          ),
          const SizedBox(height: 12.0),
          TextFormField(
            controller: _dosageController,
            decoration: const InputDecoration(
              labelText: 'Дозировка (необязательно)',
              hintText: 'Например, 1 таблетка или 25 мг',
            ),
          ),
          const SizedBox(height: 12.0),
           Row(
            children: [
              Expanded(
                child: Text(
                  _selectedTime == null
                      ? 'Время не выбрано'
                      : 'Время: ${timeFormatter.formatTimeOfDay(_selectedTime!, alwaysUse24HourFormat: true)}',
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.access_time),
                label: const Text('Выбрать время'),
                onPressed: () => _pickTime(context),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_task_outlined),
            label: const Text('Добавить лекарство'),
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          ),
        ],
      ),
    );
  }
}

