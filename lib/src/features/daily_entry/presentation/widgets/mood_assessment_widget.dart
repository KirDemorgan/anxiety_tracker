import 'package:flutter/material.dart';
import '../../../../data/models/daily_mood_entry.dart';
import 'mood_rating_input_widget.dart';

// Виджет для оценки состояния (утро, день, вечер).
class MoodAssessmentWidget extends StatefulWidget {
  final DateTime selectedDate;
  final DailyMoodEntry? initialMoodEntry; // Для редактирования существующей записи
  final Function(DailyMoodEntry) onSave;

  const MoodAssessmentWidget({
    super.key,
    required this.selectedDate,
    this.initialMoodEntry,
    required this.onSave,
  });

  @override
  State<MoodAssessmentWidget> createState() => _MoodAssessmentWidgetState();
}

class _MoodAssessmentWidgetState extends State<MoodAssessmentWidget> {
  double? _morningMood;
  double? _dayMood;
  double? _eveningMood;

  @override
  void initState() {
    super.initState();
    _updateMoodsFromInitialEntry(widget.initialMoodEntry);
  }

  // Этот метод вызывается, когда виджет перестраивается с новым initialMoodEntry
  // (например, при выборе другого дня с уже существующими данными о настроении).
  @override
  void didUpdateWidget(covariant MoodAssessmentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Только обновляем стейт, если initialMoodEntry действительно изменился.
    // Сравнение по ссылке или по значению, если DailyMoodEntry реализует operator==
    if (widget.initialMoodEntry != oldWidget.initialMoodEntry) {
       _updateMoodsFromInitialEntry(widget.initialMoodEntry);
    }
  }

  void _updateMoodsFromInitialEntry(DailyMoodEntry? entry) {
    setState(() { // Обернуть в setState, чтобы UI обновился при смене initialMoodEntry
      if (entry != null) {
        _morningMood = entry.morningMood?.toDouble();
        _dayMood = entry.dayMood?.toDouble();
        _eveningMood = entry.eveningMood?.toDouble();
      } else {
        _morningMood = null;
        _dayMood = null;
        _eveningMood = null;
      }
    });
  }


  void _saveMoods() {
    if (_morningMood == null && _dayMood == null && _eveningMood == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, оцените настроение хотя бы за один период.')),
      );
      return;
    }

    // Если initialMoodEntry существует, используем его ID, иначе ID будет null (для новой записи)
    final moodEntry = DailyMoodEntry(
      id: widget.initialMoodEntry?.id, 
      date: widget.selectedDate, // Это DateTime с временем 00:00:00
      morningMood: _morningMood?.round(),
      dayMood: _dayMood?.round(),
      eveningMood: _eveningMood?.round(),
    );
    widget.onSave(moodEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MoodRatingInputWidget(
          label: 'Утро',
          value: _morningMood,
          onChanged: (value) {
            setState(() {
              _morningMood = value;
            });
          },
        ),
        const SizedBox(height: 12.0),
        MoodRatingInputWidget(
          label: 'День',
          value: _dayMood,
          onChanged: (value) {
            setState(() {
              _dayMood = value;
            });
          },
        ),
        const SizedBox(height: 12.0),
        MoodRatingInputWidget(
          label: 'Вечер',
          value: _eveningMood,
          onChanged: (value) {
            setState(() {
              _eveningMood = value;
            });
          },
        ),
        const SizedBox(height: 20.0),
        ElevatedButton.icon(
          icon: const Icon(Icons.save_alt_outlined),
          label: const Text('Сохранить настроение'),
          onPressed: _saveMoods,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
        ),
      ],
    );
  }
}

