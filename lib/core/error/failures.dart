import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
  
  @override
  String toString() => message;
}

/// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

/// Cache failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Camera failures
class CameraFailure extends Failure {
  const CameraFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Translation failures
class TranslationFailure extends Failure {
  const TranslationFailure(super.message);
}

class MissingLanguageModelFailure extends TranslationFailure {
  final List<String> missingLanguageCodes;

  const MissingLanguageModelFailure(super.message, this.missingLanguageCodes);

  @override
  List<Object> get props => [message, missingLanguageCodes];
}

/// ML Kit failures
class MLKitFailure extends Failure {
  const MLKitFailure(super.message);
}

/// Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}


