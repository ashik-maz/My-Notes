import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_wrapper.dart';
import 'features/notes/data/datasources/note_remote_datasource.dart';
import 'firebase_options.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
  }

  // Initialize Dependency Injection container
  initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Notes',
      debugShowCheckedModeBanner: false,
      
      // Beautiful Light Theme with Slate & Indigo accents
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF6366F1), // Modern Violet/Indigo
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Sleek light gray/blue slate
        cardColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF14B8A6), // Vibrant Teal
          surface: const Color(0xFFF8FAFC),
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
