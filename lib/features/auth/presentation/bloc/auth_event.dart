import 'package:photo_remix/features/auth/domain/entities/user_entity.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {} // app start

class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  AuthUserChanged(this.user);
}

class AuthSignedOut extends AuthEvent {}
