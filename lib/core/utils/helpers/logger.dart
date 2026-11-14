import 'package:flutter/foundation.dart';
import '../../config/app_config.dart';

class Logger {
  static void debug(String message) {
    if (AppConfig.enableLogging) {
      debugPrint('[DEBUG] $message');
    }
  }

  static void info(String message) {
    if (AppConfig.enableLogging) {
      debugPrint('[INFO] $message');
    }
  }

  static void warning(String message) {
    if (AppConfig.enableLogging) {
      debugPrint('[WARNING] $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      debugPrint('[ERROR] $message');
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }
}
