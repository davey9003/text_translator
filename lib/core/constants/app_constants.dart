class AppConstants {
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultIconSize = 24.0;
  
  // Camera Constants
  static const double cameraAspectRatio = 16 / 9;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  
  // Translation Constants
  static const int maxTextLength = 5000;
  static const int minTextLength = 1;
  static const int maxHistoryItems = 100;
  
  // Storage Keys
  static const String settingsKey = 'app_settings';
  static const String historyKey = 'translation_history';
  static const String firstLaunchKey = 'first_launch';
}

