import '../../../../data/database/daos/note_dao.dart';
import '../../../../data/models/note.dart';
import '../../domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteDao _dao;

  NoteRepositoryImpl(this._dao);

  @override
  Future<int> addNote(Note note) async {
    try {
      return await _dao.insertNote(note);
    } catch (e) {
      // print('Error adding note: $e');
      rethrow;
    }
  }

  @override
  Future<List<Note>> getNotesForDate(DateTime date) async {
    try {
      return await _dao.getNotesByDate(date);
    } catch (e) {
      // print('Error fetching notes for $date: $e');
      return [];
    }
  }

  @override
  Future<void> updateNote(Note note) async {
    try {
      await _dao.updateNote(note);
    } catch (e) {
      // print('Error updating note ${note.id}: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteNote(int noteId) async {
    try {
      await _dao.deleteNote(noteId);
    } catch (e) {
      // print('Error deleting note $noteId: $e');
      rethrow;
    }
  }
}
