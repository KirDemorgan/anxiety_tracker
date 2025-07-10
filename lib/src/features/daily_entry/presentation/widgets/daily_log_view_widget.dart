import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/note.dart';
import '../../../../data/models/medication.dart';
import '../../../../data/models/daily_mood_entry.dart';
import '../providers/daily_data_provider.dart';
import 'calendar_widget.dart';
import 'daily_data_display_widget.dart';
import 'note_entry_form_widget.dart';
import 'medication_entry_form_widget.dart';
import 'mood_assessment_widget.dart';

class DailyLogViewWidget extends StatefulWidget {
  const DailyLogViewWidget({super.key});

  @override
  State<DailyLogViewWidget> createState() => _DailyLogViewWidgetState();
}

class _DailyLogViewWidgetState extends State<DailyLogViewWidget> {
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DailyDataProvider>(context, listen: false);
      if (provider.selectedDate.day != DateTime.now().day || 
          provider.selectedDate.month != DateTime.now().month ||
          provider.selectedDate.year != DateTime.now().year) {
             provider.loadDataForDay(DateTime.now());
      } else if (provider.notes.isEmpty && provider.medications.isEmpty && provider.moodEntry == null) {
         provider.loadDataForDay(provider.selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dailyDataProvider = Provider.of<DailyDataProvider>(context);
    String formattedDate = DateFormat('dd MMMM yyyy', 'ru_RU').format(dailyDataProvider.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Дневник за $formattedDate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CalendarWidget(
              selectedDay: dailyDataProvider.selectedDate,
              focusedDay: _focusedDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                dailyDataProvider.loadDataForDay(selectedDay);
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            if (dailyDataProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (dailyDataProvider.error != null)
              Center(child: Text('Ошибка: ${dailyDataProvider.error}', style: const TextStyle(color: Colors.red)))
            else
              DailyDataDisplayWidget(
                selectedDate: dailyDataProvider.selectedDate,
                notes: dailyDataProvider.notes,
                medications: dailyDataProvider.medications,
                moodEntry: dailyDataProvider.moodEntry,
              ),
            
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            _buildSectionCard(
              title: 'Добавить Заметку',
              child: NoteEntryFormWidget(
                selectedDate: dailyDataProvider.selectedDate,
                onSave: (Note newNote) {
                  dailyDataProvider.addNote(newNote).then((_) {
                     if (mounted && dailyDataProvider.error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Заметка добавлена')),
                        );
                      }
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),

            _buildSectionCard(
              title: 'Добавить Лекарство',
              child: MedicationEntryFormWidget(
                selectedDate: dailyDataProvider.selectedDate,
                onSave: (Medication newMedication) {
                  dailyDataProvider.addMedication(newMedication).then((_) {
                     if (mounted && dailyDataProvider.error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Лекарство добавлено')),
                        );
                      }
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),

            _buildSectionCard(
              title: 'Оценка Состояния',
              child: MoodAssessmentWidget(
                key: ValueKey(dailyDataProvider.selectedDate.toString() + (dailyDataProvider.moodEntry?.id?.toString() ?? 'new')), // Ключ для пересоздания с новыми initial данными
                selectedDate: dailyDataProvider.selectedDate,
                initialMoodEntry: dailyDataProvider.moodEntry,
                onSave: (DailyMoodEntry newMoodEntry) {
                  dailyDataProvider.saveMoodEntry(newMoodEntry).then((_) {
                     if (mounted && dailyDataProvider.error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Настроение сохранено')),
                        );
                      }
                  });
                },
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            child,
          ],
        ),
      ),
    );
  }
}
