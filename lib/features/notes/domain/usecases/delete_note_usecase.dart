import '../../../../core/usecase/usecase.dart';
import '../repositories/note_repository.dart';

class DeleteNoteUseCase implements UseCase<void, String> {
  final NoteRepository _repository;

  DeleteNoteUseCase(this._repository);

  @override
  Future<void> call(String id) {
    return _repository.deleteNote(id);
  }
}
