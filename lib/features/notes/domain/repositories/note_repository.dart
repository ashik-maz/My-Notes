import '../entities/note_entity.dart';

abstract class NoteRepository {
  Stream<List<NoteEntity>> getNotes(String userId);
  
  Future<void> addNote(String title, String description, String userId);
  
  Future<void> updateNote(String id, String title, String description);
  
  Future<void> deleteNote(String id);
}
