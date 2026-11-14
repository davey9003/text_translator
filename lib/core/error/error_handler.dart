import '../error/exceptions.dart';
import '../error/failures.dart';

class ErrorHandler {
  static Failure mapExceptionToFailure(Object exception) {
    if (exception is MissingLanguageModelException) {
      return MissingLanguageModelFailure(
        exception.message,
        exception.missingLanguageCodes,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is TimeoutException) {
      return TimeoutFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is CameraException) {
      return CameraFailure(exception.message);
    } else if (exception is PermissionException) {
      return PermissionFailure(exception.message);
    } else if (exception is TranslationException) {
      return TranslationFailure(exception.message);
    } else if (exception is MLKitException) {
      return MLKitFailure(exception.message);
    } else {
      return UnknownFailure(exception.toString());
    }
  }
  
  static String getErrorMessage(Failure failure) {
    return failure.message;
  }
}


