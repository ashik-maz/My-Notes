import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  const NoteModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.userId,
  });

  // Convert NoteModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
    };
  }

  // Create NoteModel from DocumentSnapshot
  factory NoteModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    
    final title = data?['title'] as String? ?? '';
    final description = data?['description'] as String? ?? '';
    final userId = data?['userId'] as String? ?? '';
    
    DateTime createdAtDate;
    final timestamp = data?['createdAt'];
    if (timestamp is Timestamp) {
      createdAtDate = timestamp.toDate();
    } else {
      createdAtDate = DateTime.now();
    }

    return NoteModel(
      id: doc.id,
      title: title,
      description: description,
      createdAt: createdAtDate,
      userId: userId,
    );
  }

  // Copy with utility
  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    String? userId,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}
