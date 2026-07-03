import 'package:flutter/material.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_in_anonymously_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/auth_state_changes_usecase.dart';

class AuthNotifier extends ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInAnonymouslyUseCase _signInAnonymouslyUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthStateChangesUseCase _authStateChangesUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  UserEntity? _user;

  AuthNotifier({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignInAnonymouslyUseCase signInAnonymouslyUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthStateChangesUseCase authStateChangesUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signInAnonymouslyUseCase = signInAnonymouslyUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _authStateChangesUseCase = authStateChangesUseCase {
    // Set initial user
    _user = _getCurrentUserUseCase();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserEntity? get currentUser => _user;

  // Stream observing auth status
  Stream<UserEntity?> get authStateChanges => _authStateChangesUseCase(NoParams());

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Sign In Email/Password
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final loggedInUser = await _signInUseCase(
        SignInParams(email: email, password: password),
      );
      _user = loggedInUser;
      _setLoading(false);
      return loggedInUser != null;
    } catch (e) {
      _errorMessage = e.toString().split(']').last.trim();
      _setLoading(false);
      return false;
    }
  }

  // Sign Up Email/Password
  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final registeredUser = await _signUpUseCase(
        SignUpParams(name: name, email: email, password: password),
      );
      _user = registeredUser;
      _setLoading(false);
      return registeredUser != null;
    } catch (e) {
      _errorMessage = e.toString().split(']').last.trim();
      _setLoading(false);
      return false;
    }
  }

  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    try {
      final googleUser = await _signInWithGoogleUseCase(NoParams());
      _user = googleUser;
      _setLoading(false);
      return googleUser != null;
    } catch (e) {
      _errorMessage = e.toString().split(']').last.trim();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    _setLoading(true);
    _clearError();
    try {
      final anonUser = await _signInAnonymouslyUseCase(NoParams());
      _user = anonUser;
      _setLoading(false);
      return anonUser != null;
    } catch (e) {
      _errorMessage = e.toString().split(']').last.trim();
      _setLoading(false);
      return false;
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    try {
      await _resetPasswordUseCase(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().split(']').last.trim();
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _signOutUseCase(NoParams());
      _user = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
}
