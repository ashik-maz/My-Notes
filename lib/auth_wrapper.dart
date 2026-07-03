import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'features/auth/domain/entities/user_entity.dart';
import 'features/auth/presentation/controllers/auth_notifier.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/notes/presentation/screens/notes_list_screen.dart';
import 'service_locator.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authNotifier = sl<AuthNotifier>();

    return StreamBuilder<UserEntity?>(
      stream: authNotifier.authStateChanges,
      builder: (context, snapshot) {
        // If the connection is waiting, show a splash loading screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFoldingCube(
                    color: theme.primaryColor,
                    size: 50.0,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Loading Notes...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          // User is authenticated, show notes list
          return const NotesListScreen();
        } else {
          // User is not authenticated, show login page
          return const LoginScreen();
        }
      },
    );
  }
}
