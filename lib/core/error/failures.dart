// Base failure class for all app failures
abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Remote data failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Local data failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

