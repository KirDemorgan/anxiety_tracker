import 'package:flutter/foundation.dart';
import '../../../../data/models/daily_mood_entry.dart';
import '../../../../data/models/note.dart';
import '../../../../data/models/medication.dart';
import '../../domain/repositories/daily_mood_entry_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/medication_repository.dart';

class DailyDataProvider with ChangeNotifier {
  final DailyMoodEntryRepository _dailyMoodEntryRepository;
  final NoteRepository _noteRepository;
  final MedicationRepository _medicationRepository;

  DailyDataProvider({
    required DailyMoodEntryRepository dailyMoodEntryRepository,
    required NoteRepository noteRepository,
    required MedicationRepository medicationRepository,
  })  : _dailyMoodEntryRepository = dailyMoodEntryRepository,
        _noteRepository = noteRepository,
        _medicationRepository = medicationRepository;

  DateTime _selectedDate = DateTime.now();
  DailyMoodEntry? _moodEntry;
  List<Note> _notes = [];
  List<Medication> _medications = [];
  bool _isLoading = false;
  String? _error;

  DateTime get selectedDate => _selectedDate;
  DailyMoodEntry? get moodEntry => _moodEntry;
  List<Note> get notes => _notes;
  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDataForDay(DateTime date) async {
    _selectedDate = date;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _moodEntry = await _dailyMoodEntryRepository.getDailyMoodEntry(date);
      _notes = await _noteRepository.getNotesForDate(date);
      _medications = await _medicationRepository.getMedicationsForDate(date);
    } catch (e) {
      _error = "Не удалось загрузить данные: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveMoodEntry(DailyMoodEntry entry) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _dailyMoodEntryRepository.saveDailyMoodEntry(entry);
      await loadDataForDay(_selectedDate);
    } catch (e) {
      _error = "Не удалось сохранить настроение: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(Note note) async {
     _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _noteRepository.addNote(note.copyWith(date: _selectedDate));
      await loadDataForDay(_selectedDate);
    } catch (e) {
       _error = "Не удалось добавить заметку: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNote(Note note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _noteRepository.updateNote(note);
      await loadDataForDay(_selectedDate);
    } catch (e) {
      _error = "Не удалось обновить заметку: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNote(int noteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _noteRepository.deleteNote(noteId);
      await loadDataForDay(_selectedDate);
    } catch (e) {
      _error = "Не удалось удалить заметку: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication(Medication medication) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _medicationRepository.addMedication(medication.copyWith(date: _selectedDate));
      await loadDataForDay(_selectedDate);
    } catch (e) {
      _error = "Не удалось добавить лекарство: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateMedication(Medication medication) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _medicationRepository.updateMedication(medication);
      await loadDataForDay(_selectedDate);
    } catch (e) {
       _error = "Не удалось обновить лекарство: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMedication(int medicationId) async {
     _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _medicationRepository.deleteMedication(medicationId);
      await loadDataForDay(_selectedDate);
    } catch (e) {
      _error = "Не удалось удалить лекарство: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
