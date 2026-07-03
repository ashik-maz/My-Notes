import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String name;
  final String email;
  final String password;

  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignUpUseCase implements UseCase<UserEntity?, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<UserEntity?> call(SignUpParams params) {
    return _repository.signUpWithEmail(params.name, params.email, params.password);
  }
}
