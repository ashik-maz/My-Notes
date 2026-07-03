import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Stream<List<NoteModel>> getNotes(String userId);
  Future<void> addNote(String title, String description, String userId);
  Future<void> updateNote(String id, String title, String description);
  Future<void> deleteNote(String id);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  // Global flag to toggle between Live Firestore and Demo In-Memory mode
  static bool isDemoMode = false;

  // In-memory mock database for Demo Mode
  static final List<NoteModel> _mockNotes = [
    NoteModel(
      id: 'mock-1',
      title: 'Welcome to NoteApp! 📝',
      description: 'This app is running in Demo Mode because Firebase is not configured yet. Follow the README to connect it to your Cloud Firestore database!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      userId: 'mock-user-123',
    ),
    NoteModel(
      id: 'mock-2',
      title: 'Assignment Guidelines 🎓',
      description: 'Complete CRUD operations are implemented. You can create, read, update, and delete notes.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      userId: 'mock-user-123',
    ),
    NoteModel(
      id: 'mock-3',
      title: 'Beautiful UI Design ✨',
      description: 'Features gradients, modern typography (Google Fonts), search filtering, layout switching (List/Grid), and elegant loading indicators.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      userId: 'mock-user-123',
    ),
  ];

  // Stream controller to broadcast mock changes
  static final StreamController<List<NoteModel>> _mockStreamController =
      StreamController<List<NoteModel>>.broadcast();

  // Firestore Collection reference
  CollectionReference? get _notesCollection {
    try {
      return FirebaseFirestore.instance.collection('notes');
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<List<NoteModel>> getNotes(String userId) {
    if (isDemoMode) {
      // Filter mock notes by user ID
      final userNotes = _mockNotes.where((note) => note.userId == userId).toList();
      scheduleMicrotask(() => _mockStreamController.add(List.unmodifiable(userNotes)));
      return _mockStreamController.stream;
    }

    try {
      final collection = _notesCollection;
      if (collection == null) {
        throw Exception('Firebase not initialized');
      }
      return collection
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        final list = snapshot.docs.map((doc) => NoteModel.fromDocument(doc)).toList();
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      });
    } catch (e) {
      print("Firestore error fetching notes, switching to Demo Mode: $e");
      isDemoMode = true;
      final userNotes = _mockNotes.where((note) => note.userId == userId).toList();
      scheduleMicrotask(() => _mockStreamController.add(List.unmodifiable(userNotes)));
      return _mockStreamController.stream;
    }
  }

  @override
  Future<void> addNote(String title, String description, String userId) async {
    if (isDemoMode) {
      final newNote = NoteModel(
        id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        createdAt: DateTime.now(),
        userId: userId,
      );
      _mockNotes.insert(0, newNote);
      
      // Notify only notes belonging to this user
      final userNotes = _mockNotes.where((note) => note.userId == userId).toList();
      _mockStreamController.add(List.unmodifiable(userNotes));
      return;
    }

    final collection = _notesCollection;
    if (collection == null) throw Exception('Firebase not initialized');
    await collection.add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': userId,
    });
  }

  @override
  Future<void> updateNote(String id, String title, String description) async {
    if (isDemoMode) {
      final index = _mockNotes.indexWhere((note) => note.id == id);
      if (index != -1) {
        final userId = _mockNotes[index].userId;
        _mockNotes[index] = _mockNotes[index].copyWith(
          title: title,
          description: description,
        );
        final userNotes = _mockNotes.where((note) => note.userId == userId).toList();
        _mockStreamController.add(List.unmodifiable(userNotes));
      }
      return;
    }

    final collection = _notesCollection;
    if (collection == null) throw Exception('Firebase not initialized');
    await collection.doc(id).update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteNote(String id) async {
    if (isDemoMode) {
      final index = _mockNotes.indexWhere((note) => note.id == id);
      if (index != -1) {
        final userId = _mockNotes[index].userId;
        _mockNotes.removeAt(index);
        final userNotes = _mockNotes.where((note) => note.userId == userId).toList();
        _mockStreamController.add(List.unmodifiable(userNotes));
      }
      return;
    }

    final collection = _notesCollection;
    if (collection == null) throw Exception('Firebase not initialized');
    await collection.doc(id).delete();
  }
}
