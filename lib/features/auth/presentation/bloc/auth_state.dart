import 'package:photo_remix/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  unknown, // app just started
  authenticated, // signed in (anon or normal)
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final UserEntity? user;

  const AuthState({required this.status, this.user});

  factory AuthState.unknown() => const AuthState(status: AuthStatus.unknown);

  AuthState copyWith({AuthStatus? status, UserEntity? user}) {
    return AuthState(status: status ?? this.status, user: user ?? this.user);
  }
}
