// Base use case interface
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// Use case with no parameters
abstract class UseCaseNoParams<Type> {
  Future<Type> call();
}

// No parameters class
class NoParams {
  const NoParams();
}
