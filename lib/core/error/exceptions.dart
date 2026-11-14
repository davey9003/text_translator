/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final dynamic originalError;
  
  const AppException(this.message, [this.originalError]);
  
  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, [super.originalError]);
}

class ServerException extends AppException {
  const ServerException(super.message, [super.originalError]);
}

class TimeoutException extends AppException {
  const TimeoutException(super.message, [super.originalError]);
}

/// Local storage exceptions
class CacheException extends AppException {
  const CacheException(super.message, [super.originalError]);
}

class StorageException extends AppException {
  const StorageException(super.message, [super.originalError]);
}

/// Camera-related exceptions
class CameraException extends AppException {
  const CameraException(super.message, [super.originalError]);
}

class PermissionException extends AppException {
  const PermissionException(super.message, [super.originalError]);
}

/// Translation-related exceptions
class TranslationException extends AppException {
  const TranslationException(super.message, [super.originalError]);
}

class MissingLanguageModelException extends TranslationException {
  final List<String> missingLanguageCodes;

  const MissingLanguageModelException(
    super.message,
    this.missingLanguageCodes, [
    super.originalError,
  ]);
}

/// ML Kit exceptions
class MLKitException extends AppException {
  const MLKitException(super.message, [super.originalError]);
}


