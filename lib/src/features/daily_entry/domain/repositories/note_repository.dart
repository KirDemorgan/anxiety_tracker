import '../../../../data/models/note.dart';

abstract class NoteRepository {
  Future<int> addNote(Note note);
  Future<List<Note>> getNotesForDate(DateTime date);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(int noteId);
}
