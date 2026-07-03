import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../notes/data/datasources/note_remote_datasource.dart'; // To get isDemoMode
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> signInWithEmail(String email, String password);
  Future<UserModel?> signUpWithEmail(String name, String email, String password);
  Future<UserModel?> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  UserModel? get currentUser;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  GoogleSignIn? _googleSignInInstance;
  GoogleSignIn get _googleSignIn {
    _googleSignInInstance ??= GoogleSignIn();
    return _googleSignInInstance!;
  }

  // Completer to protect Firebase calls from being made before initialization finishes
  static final Completer<void> _initCompleter = Completer<void>();

  static void setInitialized() {
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  // Lazy-load FirebaseAuth so it doesn't throw on initialization if Firebase is offline/not configured
  FirebaseAuth get _auth => FirebaseAuth.instance;

  bool get _isDemoMode => NoteRemoteDataSourceImpl.isDemoMode;

  // In-memory session mock variables
  static UserModel? _mockUser;
  static final StreamController<UserModel?> _mockUserStreamController =
      StreamController<UserModel?>.broadcast();

  @override
  Stream<UserModel?> get authStateChanges {
    final controller = StreamController<UserModel?>.broadcast();

    _initCompleter.future.then((_) {
      if (_isDemoMode) {
        scheduleMicrotask(() => _mockUserStreamController.add(_mockUser));
        _mockUserStreamController.stream.listen(controller.add, onError: controller.addError);
      } else {
        _auth.authStateChanges().map((user) {
          if (user == null) return null;
          return UserModel.fromFirebase(user);
        }).listen(controller.add, onError: controller.addError);
      }
    });

    return controller.stream;
  }

  @override
  UserModel? get currentUser {
    if (_isDemoMode) {
      return _mockUser;
    }

    if (!_initCompleter.isCompleted) {
      return null;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      return UserModel.fromFirebase(user);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmail(String email, String password) async {
    if (_isDemoMode) {
      _mockUser = UserModel(
        uid: 'mock-user-123',
        email: email,
        displayName: email.split('@')[0].toUpperCase(),
      );
      _mockUserStreamController.add(_mockUser);
      return _mockUser;
    }

    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) return null;
    return UserModel.fromFirebase(credential.user!);
  }

  @override
  Future<UserModel?> signUpWithEmail(String name, String email, String password) async {
    if (_isDemoMode) {
      _mockUser = UserModel(
        uid: 'mock-user-123',
        email: email,
        displayName: name,
      );
      _mockUserStreamController.add(_mockUser);
      return _mockUser;
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) return null;

    // Update Firebase display name profile
    await credential.user!.updateDisplayName(name);

    return UserModel(
      uid: credential.user!.uid,
      email: credential.user!.email,
      displayName: name,
    );
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    if (_isDemoMode) {
      _mockUser = const UserModel(
        uid: 'mock-google-user',
        email: 'googleuser@gmail.com',
        displayName: 'Google Demo User',
      );
      _mockUserStreamController.add(_mockUser);
      return _mockUser;
    }

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user == null) return null;
    return UserModel.fromFirebase(userCredential.user!);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (_isDemoMode) return;
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    if (_isDemoMode) {
      _mockUser = null;
      _mockUserStreamController.add(null);
      return;
    }

    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
