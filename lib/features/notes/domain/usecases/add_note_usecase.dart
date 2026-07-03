import '../../../../core/usecase/usecase.dart';
import '../repositories/note_repository.dart';

class AddNoteParams {
  final String title;
  final String description;
  final String userId;

  AddNoteParams({
    required this.title,
    required this.description,
    required this.userId,
  });
}

class AddNoteUseCase implements UseCase<void, AddNoteParams> {
  final NoteRepository _repository;

  AddNoteUseCase(this._repository);

  @override
  Future<void> call(AddNoteParams params) {
    return _repository.addNote(
      params.title,
      params.description,
      params.userId,
    );
  }
}
