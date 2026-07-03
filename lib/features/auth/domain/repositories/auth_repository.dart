import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  
  Future<UserEntity?> signInWithEmail(String email, String password);
  
  Future<UserEntity?> signUpWithEmail(String name, String email, String password);
  
  Future<UserEntity?> signInWithGoogle();
  
  Future<UserEntity?> signInAnonymously();
  
  Future<void> sendPasswordResetEmail(String email);
  
  Future<void> signOut();
  
  UserEntity? get currentUser;
}
