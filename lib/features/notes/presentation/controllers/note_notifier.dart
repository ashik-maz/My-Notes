import 'package:flutter/material.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';

class NoteNotifier extends ChangeNotifier {
  final GetNotesUseCase _getNotesUseCase;
  final AddNoteUseCase _addNoteUseCase;
  final UpdateNoteUseCase _updateNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;

  bool _isLoading = false;
  String? _errorMessage;

  NoteNotifier({
    required GetNotesUseCase getNotesUseCase,
    required AddNoteUseCase addNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
  })  : _getNotesUseCase = getNotesUseCase,
        _addNoteUseCase = addNoteUseCase,
        _updateNoteUseCase = updateNoteUseCase,
        _deleteNoteUseCase = deleteNoteUseCase;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Get Notes Stream for the logged-in user
  Stream<List<NoteEntity>> getNotes(String userId) {
    return _getNotesUseCase(userId);
  }

  // Create Note
  Future<bool> addNote(String title, String description, String userId) async {
    _setLoading(true);
    _clearError();
    try {
      await _addNoteUseCase(
        AddNoteParams(title: title, description: description, userId: userId),
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Update Note
  Future<bool> updateNote(String id, String title, String description) async {
    _setLoading(true);
    _clearError();
    try {
      await _updateNoteUseCase(
        UpdateNoteParams(id: id, title: title, description: description),
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Delete Note
  Future<bool> deleteNote(String id) async {
    _setLoading(true);
    _clearError();
    try {
      await _deleteNoteUseCase(id);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }
}
