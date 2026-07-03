import '../../../../core/usecase/usecase.dart';
import '../repositories/note_repository.dart';

class UpdateNoteParams {
  final String id;
  final String title;
  final String description;

  UpdateNoteParams({
    required this.id,
    required this.title,
    required this.description,
  });
}

class UpdateNoteUseCase implements UseCase<void, UpdateNoteParams> {
  final NoteRepository _repository;

  UpdateNoteUseCase(this._repository);

  @override
  Future<void> call(UpdateNoteParams params) {
    return _repository.updateNote(
      params.id,
      params.title,
      params.description,
    );
  }
}
