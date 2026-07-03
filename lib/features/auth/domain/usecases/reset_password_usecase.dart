import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<void, String> {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Future<void> call(String params) {
    return _repository.sendPasswordResetEmail(params);
  }
}
