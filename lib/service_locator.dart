import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_state_changes_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/domain/usecases/sign_in_anonymously_usecase.dart';
import 'features/auth/presentation/controllers/auth_notifier.dart';
import 'features/notes/data/datasources/note_remote_datasource.dart';
import 'features/notes/data/repositories/note_repository_impl.dart';
import 'features/notes/domain/repositories/note_repository.dart';
import 'features/notes/domain/usecases/add_note_usecase.dart';
import 'features/notes/domain/usecases/delete_note_usecase.dart';
import 'features/notes/domain/usecases/get_notes_usecase.dart';
import 'features/notes/domain/usecases/update_note_usecase.dart';
import 'features/notes/presentation/controllers/note_notifier.dart';

class ServiceLocator {
  final Map<Type, Object> _instances = {};

  void registerSingleton<T extends Object>(T instance) {
    _instances[T] = instance;
  }

  T call<T extends Object>() {
    final instance = _instances[T];
    if (instance == null) {
      throw Exception("Dependency of type $T not registered in ServiceLocator");
    }
    return instance as T;
  }
}

// Global service locator instance
final sl = ServiceLocator();

void initDependencies() {
  // 1. Data Sources
  final authRemoteDataSource = AuthRemoteDataSourceImpl();
  final noteRemoteDataSource = NoteRemoteDataSourceImpl();
  sl.registerSingleton<AuthRemoteDataSource>(authRemoteDataSource);
  sl.registerSingleton<NoteRemoteDataSource>(noteRemoteDataSource);

  // 2. Repositories
  final authRepository = AuthRepositoryImpl(sl<AuthRemoteDataSource>());
  final noteRepository = NoteRepositoryImpl(sl<NoteRemoteDataSource>());
  sl.registerSingleton<AuthRepository>(authRepository);
  sl.registerSingleton<NoteRepository>(noteRepository);

  // 3. Use Cases (Auth)
  sl.registerSingleton<SignInUseCase>(SignInUseCase(sl<AuthRepository>()));
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase(sl<AuthRepository>()));
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase(sl<AuthRepository>()));
  sl.registerSingleton<SignInWithGoogleUseCase>(SignInWithGoogleUseCase(sl<AuthRepository>()));
  sl.registerSingleton<ResetPasswordUseCase>(ResetPasswordUseCase(sl<AuthRepository>()));
  sl.registerSingleton<SignInAnonymouslyUseCase>(SignInAnonymouslyUseCase(sl<AuthRepository>()));
  sl.registerSingleton<GetCurrentUserUseCase>(GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerSingleton<AuthStateChangesUseCase>(AuthStateChangesUseCase(sl<AuthRepository>()));

  // 3. Use Cases (Notes)
  sl.registerSingleton<GetNotesUseCase>(GetNotesUseCase(sl<NoteRepository>()));
  sl.registerSingleton<AddNoteUseCase>(AddNoteUseCase(sl<NoteRepository>()));
  sl.registerSingleton<UpdateNoteUseCase>(UpdateNoteUseCase(sl<NoteRepository>()));
  sl.registerSingleton<DeleteNoteUseCase>(DeleteNoteUseCase(sl<NoteRepository>()));

  // 4. Notifiers (Presentation State)
  final authNotifier = AuthNotifier(
    signInUseCase: sl<SignInUseCase>(),
    signUpUseCase: sl<SignUpUseCase>(),
    signOutUseCase: sl<SignOutUseCase>(),
    signInWithGoogleUseCase: sl<SignInWithGoogleUseCase>(),
    signInAnonymouslyUseCase: sl<SignInAnonymouslyUseCase>(),
    resetPasswordUseCase: sl<ResetPasswordUseCase>(),
    getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
    authStateChangesUseCase: sl<AuthStateChangesUseCase>(),
  );
  
  final noteNotifier = NoteNotifier(
    getNotesUseCase: sl<GetNotesUseCase>(),
    addNoteUseCase: sl<AddNoteUseCase>(),
    updateNoteUseCase: sl<UpdateNoteUseCase>(),
    deleteNoteUseCase: sl<DeleteNoteUseCase>(),
  );

  sl.registerSingleton<AuthNotifier>(authNotifier);
  sl.registerSingleton<NoteNotifier>(noteNotifier);
}
