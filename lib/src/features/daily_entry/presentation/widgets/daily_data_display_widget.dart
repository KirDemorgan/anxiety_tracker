import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/note.dart';
import '../../../../data/models/medication.dart';
import '../../../../data/models/daily_mood_entry.dart';
import '../providers/daily_data_provider.dart';
import 'note_item_widget.dart';
import 'medication_item_widget.dart';


// Виджет для отображения данных (настроение, заметки, лекарства) за выбранный день.
class DailyDataDisplayWidget extends StatelessWidget {
  final DateTime selectedDate;
  // Данные теперь приходят из провайдера, но для совместимости оставим возможность передавать напрямую, если нужно
  final List<Note> notes;
  final List<Medication> medications;
  final DailyMoodEntry? moodEntry;


  const DailyDataDisplayWidget({
    super.key,
    required this.selectedDate, // selectedDate все еще нужен для отображения заголовка даты
    required this.notes,
    required this.medications,
    this.moodEntry,
  });

  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('dd MMMM yyyy', 'ru_RU'); // Не используется здесь напрямую
    // final timeFormat = MaterialLocalizations.of(context); // Не используется здесь напрямую

    return Card(
      elevation: 0, 
      child: Padding(
        padding: const EdgeInsets.all(0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildMoodSection(context, moodEntry),
            const SizedBox(height: 16.0),
            _buildNotesSection(context, notes),
            const SizedBox(height: 16.0),
            _buildMedicationsSection(context, medications),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSection(BuildContext context, DailyMoodEntry? currentMoodEntry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Настроение за день:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        if (currentMoodEntry == null || (currentMoodEntry.morningMood == null && currentMoodEntry.dayMood == null && currentMoodEntry.eveningMood == null))
          const Text('Данные о настроении отсутствуют.')
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _moodPill('Утро', currentMoodEntry.morningMood, context),
              _moodPill('День', currentMoodEntry.dayMood, context),
              _moodPill('Вечер', currentMoodEntry.eveningMood, context),
            ],
          ),
      ],
    );
  }

   Widget _buildNotesSection(BuildContext context, List<Note> currentNotes) {
    final dailyDataProvider = Provider.of<DailyDataProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Заметки:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        currentNotes.isEmpty
            ? const Text('Заметок на этот день нет.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];
                  return Dismissible(
                    key: Key('note_${note.id}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      dailyDataProvider.deleteNote(note.id!);
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Заметка "${note.text.substring(0, (note.text.length > 10) ? 10 : note.text.length ).trim()}..." удалена')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerEnd,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: NoteItemWidget(note: note),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildMedicationsSection(BuildContext context, List<Medication> currentMedications) {
     final dailyDataProvider = Provider.of<DailyDataProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Принятые лекарства:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        currentMedications.isEmpty
            ? const Text('Записей о приеме лекарств на этот день нет.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentMedications.length,
                itemBuilder: (context, index) {
                  final medication = currentMedications[index];
                   return Dismissible(
                    key: Key('medication_${medication.id}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      dailyDataProvider.deleteMedication(medication.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Лекарство "${medication.name}" удалено')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerEnd,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: MedicationItemWidget(medication: medication),
                  );
                },
              ),
      ],
    );
  }


  Widget _moodPill(String label, int? mood, BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Chip(
          label: Text(mood?.toString() ?? '–', style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: mood != null ? _getMoodColor(mood, context) : Colors.grey[300],
          labelStyle: TextStyle(color: mood != null ? Colors.white : Colors.black54),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      ],
    );
  }

  Color _getMoodColor(int mood, BuildContext context) {
    if (mood <= 3) return Colors.red.shade400;
    if (mood <= 7) return Colors.orange.shade400;
    return Colors.green.shade400;
  }
}

