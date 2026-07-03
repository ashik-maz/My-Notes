import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.email,
    super.displayName,
  });

  // Factory to create a UserModel from a Firebase User object
  factory UserModel.fromFirebase(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
    );
  }

  // Copy with utility
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }
}
