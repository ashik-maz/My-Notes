import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInAnonymouslyUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;

  SignInAnonymouslyUseCase(this._repository);

  @override
  Future<UserEntity?> call(NoParams params) {
    return _repository.signInAnonymously();
  }
}
