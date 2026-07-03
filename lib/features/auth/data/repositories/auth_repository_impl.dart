import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  UserEntity? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) {
    return _remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity?> signUpWithEmail(String name, String email, String password) {
    return _remoteDataSource.signUpWithEmail(name, email, password);
  }

  @override
  Future<UserEntity?> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<UserEntity?> signInAnonymously() {
    return _remoteDataSource.signInAnonymously();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}
