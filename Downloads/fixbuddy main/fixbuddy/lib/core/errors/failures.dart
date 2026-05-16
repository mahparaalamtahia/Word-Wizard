/// Failure classes for consistent error handling
abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  final String? code;

  ServerFailure({
    required super.message,
    this.code,
  });
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message});
}

class AuthFailure extends Failure {
  final String? code;

  AuthFailure({
    required super.message,
    this.code,
  });
}

class UnknownFailure extends Failure {
  UnknownFailure({required super.message});
}
