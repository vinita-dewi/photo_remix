import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_remix/features/auth/data/models/user_model.dart';
import 'package:photo_remix/features/auth/domain/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

// Repository implementation for authentication
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  // Implement repository methods here
  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = _dataSource.getCurrentFirebaseUser();
    if (firebaseUser == null) return null;
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<UserEntity> signInAnonymously() async {
    final credential = await _dataSource.signInAnonymously();
    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NULL_USER',
        message: 'FirebaseAuth returned null user after signInAnonymously.',
      );
    }
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserEntity> ensureSignedIn() async {
    final existing = await getCurrentUser();
    if (existing != null) {
      return existing;
    }
    // no user → sign in anonymously
    return signInAnonymously();
  }
}
