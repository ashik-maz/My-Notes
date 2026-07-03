import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthStateChangesUseCase implements StreamUseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;

  AuthStateChangesUseCase(this._repository);

  @override
  Stream<UserEntity?> call(NoParams params) {
    return _repository.authStateChanges;
  }
}
