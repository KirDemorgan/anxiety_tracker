import 'package:flutter/material.dart';
import '../../../../data/models/note.dart';

// Форма для добавления новой заметки.
class NoteEntryFormWidget extends StatefulWidget {
  final DateTime selectedDate; // Для привязки заметки к дате
  final Function(Note) onSave;

  const NoteEntryFormWidget({
    super.key,
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<NoteEntryFormWidget> createState() => _NoteEntryFormWidgetState();
}

class _NoteEntryFormWidgetState extends State<NoteEntryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _noteTextController = TextEditingController();
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
          const SnackBar(content: Text('Пожалуйста, выберите время заметки.')),
        );
        return;
      }

      // ID будет присвоен базой данных, поэтому здесь не указываем.
      // selectedDate уже содержит только дату (полночь).
      final newNote = Note(
        date: widget.selectedDate, // Это DateTime с временем 00:00:00
        time: _selectedTime!,
        text: _noteTextController.text,
      );
      widget.onSave(newNote);
      _noteTextController.clear(); // Очищаем поле после сохранения
      // Оставляем время для удобства добавления следующей заметки
      // setState(() { _selectedTime = TimeOfDay.now(); }); 
    }
  }

  @override
  void dispose() {
    _noteTextController.dispose();
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
            controller: _noteTextController,
            decoration: const InputDecoration(
              labelText: 'Текст заметки',
              hintText: 'Опишите свои мысли или события...',
              alignLabelWithHint: true, // Для многострочных полей
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите текст заметки.';
              }
              return null;
            },
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
            icon: const Icon(Icons.add_comment_outlined),
            label: const Text('Добавить заметку'),
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}

