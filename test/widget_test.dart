import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/main.dart';
import 'package:note_app/features/notes/data/datasources/note_remote_datasource.dart';

import 'package:note_app/service_locator.dart';
import 'package:note_app/features/auth/data/datasources/auth_remote_datasource.dart';

void main() {
  testWidgets('Notes app login screen smoke test', (WidgetTester tester) async {
    // Enable demo mode for testing so we don't depend on Firebase initialization
    NoteRemoteDataSourceImpl.isDemoMode = true;

    // Initialize dependencies
    initDependencies();

    // Mark auth datasource as initialized
    AuthRemoteDataSourceImpl.setInitialized();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Trigger state stream builder update
    await tester.pumpAndSettle();

    // Verify that the login page header is displayed.
    expect(find.text('Welcome Back!'), findsOneWidget);

    // Verify that email and password fields exist.
    expect(find.text('Email........'), findsOneWidget);
    expect(find.text('Password........'), findsOneWidget);

    // Verify that the "Sign in with Google" button exists.
    expect(find.text('Sign in with Google'), findsOneWidget);
  });
}
