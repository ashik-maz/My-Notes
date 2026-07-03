import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

class SignInUseCase implements UseCase<UserEntity?, SignInParams> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<UserEntity?> call(SignInParams params) {
    return _repository.signInWithEmail(params.email, params.password);
  }
}
