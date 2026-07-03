import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_remote_datasource.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource _remoteDataSource;

  NoteRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<NoteEntity>> getNotes(String userId) => _remoteDataSource.getNotes(userId);

  @override
  Future<void> addNote(String title, String description, String userId) {
    return _remoteDataSource.addNote(title, description, userId);
  }

  @override
  Future<void> updateNote(String id, String title, String description) {
    return _remoteDataSource.updateNote(id, title, description);
  }

  @override
  Future<void> deleteNote(String id) {
    return _remoteDataSource.deleteNote(id);
  }
}
