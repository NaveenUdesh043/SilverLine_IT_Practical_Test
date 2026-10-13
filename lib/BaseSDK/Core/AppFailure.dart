sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([
    super.message = 'Network is unreliable right now. Please try again.',
  ]);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class StorageFailure extends AppFailure {
  const StorageFailure([
    super.message = 'Could not read or write local data.',
  ]);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure([
    super.message = 'The requested item could not be found.',
  ]);
}
