import 'package:photo_remix/core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class EnsureSignedIn extends UseCase<UserEntity, NoParams> {
  final AuthRepository _authRepository;

  EnsureSignedIn(this._authRepository);

  @override
  Future<UserEntity> call(NoParams params) {
    return _authRepository.ensureSignedIn();
  }
}
