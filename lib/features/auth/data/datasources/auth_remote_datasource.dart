// Remote data source for authentication
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  User? getCurrentFirebaseUser();
  Future<UserCredential> signInAnonymously();
  Stream<User?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;

  AuthRemoteDataSourceImpl(this._auth);

  @override
  User? getCurrentFirebaseUser() => _auth.currentUser;

  @override
  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
