import '../../../../core/usecase/usecase.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetNotesUseCase implements StreamUseCase<List<NoteEntity>, String> {
  final NoteRepository _repository;

  GetNotesUseCase(this._repository);

  @override
  Stream<List<NoteEntity>> call(String userId) {
    return _repository.getNotes(userId);
  }
}
