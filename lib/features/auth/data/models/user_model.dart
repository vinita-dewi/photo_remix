import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.uid, required super.isAnonymous});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(uid: user.uid, isAnonymous: user.isAnonymous);
  }
}
