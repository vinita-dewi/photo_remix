// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

// Remote data exceptions
class ServerException extends AppException {
  const ServerException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

// Local data exceptions
class CacheException extends AppException {
  const CacheException(super.message);
}

