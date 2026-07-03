import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_wrapper.dart';
import 'features/notes/data/datasources/note_remote_datasource.dart';
import 'firebase_options.dart';
import 'service_locator.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';

void main() {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Dependency Injection container
    initDependencies();

    runApp(const MyApp());

    // Initialize Firebase in the background asynchronously
    _initializeFirebase();
  } catch (e, stack) {
    print("CRITICAL CRASH IN STARTUP: $e");
    print(stack);
  }
}

Future<void> _initializeFirebase() async {
  try {
    // Attempt to initialize Firebase with a timeout.
    // If it takes too long (e.g. slow network or blocked scripts on web),
    // we fail gracefully and run in Demo Mode.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 3));
    
    // Check if the options are still the demo placeholders
    if (DefaultFirebaseOptions.currentPlatform.apiKey.contains('replace-me')) {
      print("Firebase options are mock placeholders. Running in Demo Mode.");
      NoteRemoteDataSourceImpl.isDemoMode = true;
    }
  } catch (e) {
    print("Firebase initialization failed or timed out. Running in Demo Mode: $e");
    NoteRemoteDataSourceImpl.isDemoMode = true;
  } finally {
    // Release the init lock so Auth starts listening to sessions
    AuthRemoteDataSourceImpl.setInitialized();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Notes',
      debugShowCheckedModeBanner: false,
      
      // Beautiful Light Theme with Forest Green elements
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0C6B37), // Forest Green
        scaffoldBackgroundColor: const Color(0xFFEBF6F0), // Soft mint slate background
        cardColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0C6B37),
          primary: const Color(0xFF0C6B37),
          secondary: const Color(0xFF1B8E4B), // Lighter Green
          surface: const Color(0xFFEBF6F0),
        ),
        
        // Custom Google Fonts text theme
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xFF1E293B), // Deep slate text
            displayColor: const Color(0xFF0F172A),
          ),
        ),
        
        // Custom input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          labelStyle: GoogleFonts.outfit(color: const Color(0xFF64748B)),
          hintStyle: GoogleFonts.outfit(color: const Color(0xFF94A3B8)),
        ),
      ),
      
      home: const AuthWrapper(),
    );
  }
}
