import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_remix/core/usecases/usecase.dart';
import 'package:photo_remix/features/auth/domain/usecases/ensure_signed_in_usecase.dart';
import 'package:photo_remix/features/auth/presentation/bloc/auth_event.dart';
import 'package:photo_remix/features/auth/presentation/bloc/auth_state.dart';
import 'package:photo_remix/core/logging/app_logger.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final EnsureSignedIn _ensureSignedIn;
  final _log = AppLogger.instance;

  AuthBloc(this._ensureSignedIn) : super(AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignedOut>(_onSignedOut);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    _log.i('AuthStarted → checking auth / anonymous sign-in');
    emit(state.copyWith(status: AuthStatus.unknown));
    try {
      final user = await _ensureSignedIn(const NoParams());
      _log.i(
        'AuthStarted → authenticated uid=${user.uid} anon=${user.isAnonymous}',
      );
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (e, s) {
      _log.e(
        'AuthStarted failed, marking unauthenticated',
        error: e,
        stackTrace: s,
      );
      emit(AuthState(status: AuthStatus.unauthenticated));
    }
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user == null) {
      _log.w('AuthUserChanged → unauthenticated (null user)');
      emit(AuthState(status: AuthStatus.unauthenticated));
    } else {
      _log.i(
        'AuthUserChanged → authenticated uid=${event.user!.uid} anon=${event.user!.isAnonymous}',
      );
      emit(AuthState(status: AuthStatus.authenticated, user: event.user));
    }
  }

  void _onSignedOut(AuthSignedOut event, Emitter<AuthState> emit) {
    _log.w('AuthSignedOut → unauthenticated');
    emit(AuthState(status: AuthStatus.unauthenticated, user: null));
  }
}
