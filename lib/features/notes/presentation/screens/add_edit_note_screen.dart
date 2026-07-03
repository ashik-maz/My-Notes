import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../service_locator.dart';
import '../../../auth/presentation/controllers/auth_notifier.dart';
import '../../domain/entities/note_entity.dart';
import '../controllers/note_notifier.dart';

class AddEditNoteScreen extends StatefulWidget {
  final NoteEntity? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  
  final NoteNotifier _noteNotifier = sl<NoteNotifier>();
  final AuthNotifier _authNotifier = sl<AuthNotifier>();

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final userId = _authNotifier.currentUser?.uid ?? 'mock-user-123';

    bool success;
    if (_isEditing) {
      success = await _noteNotifier.updateNote(widget.note!.id, title, description);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildCustomSnackBar('Note updated successfully', Colors.teal),
        );
      }
    } else {
      success = await _noteNotifier.addNote(title, description, userId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildCustomSnackBar('Note created successfully', Colors.indigo),
        );
      }
    }

    if (success && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildCustomSnackBar(
          _noteNotifier.errorMessage ?? 'Error saving note',
          Colors.redAccent,
        ),
      );
    }
  }

  SnackBar _buildCustomSnackBar(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(
        message,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w500, color: Colors.white),
      ),
      backgroundColor: backgroundColor.withValues(alpha: 0.9),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Note' : 'Create Note',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _noteNotifier,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          _isEditing ? 'Modify your note details below.' : 'Write down your thoughts.',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Title Input Field
                        TextFormField(
                          controller: _titleController,
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
                          maxLength: 100,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                            hintText: 'Enter note title...',
                            prefixIcon: Icon(Icons.title, color: theme.primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: theme.primaryColor, width: 2),
                            ),
                            filled: true,
                            fillColor: theme.cardColor,
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Description Input Field
                        TextFormField(
                          controller: _descriptionController,
                          style: GoogleFonts.outfit(fontSize: 16, height: 1.5),
                          maxLines: 8,
                          minLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                            hintText: 'Enter note description...',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 80.0),
                              child: Icon(Icons.description, color: theme.primaryColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: theme.primaryColor, width: 2),
                            ),
                            filled: true,
                            fillColor: theme.cardColor,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 35),
                        
                        // Save Button
                        _noteNotifier.isLoading
                            ? Center(
                                child: SpinKitRing(
                                  color: theme.primaryColor,
                                  size: 50.0,
                                ),
                              )
                            : Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.primaryColor,
                                      theme.colorScheme.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.primaryColor.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _saveNote,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isEditing ? Icons.check : Icons.add,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _isEditing ? 'Save Changes' : 'Create Note',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
