import '../../config/app_config.dart';

class Logger {
  static void debug(String message) {
    if (AppConfig.enableLogging) {
      print('[DEBUG] $message');
    }
  }
  
  static void info(String message) {
    if (AppConfig.enableLogging) {
      print('[INFO] $message');
    }
  }
  
  static void warning(String message) {
    if (AppConfig.enableLogging) {
      print('[WARNING] $message');
    }
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      print('[ERROR] $message');
      if (error != null) {
        print('Error: $error');
      }
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }
}


