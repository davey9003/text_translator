class AppConfig {
  static const String appName = 'Lens Translate';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Translate text from camera in real-time';
  
  // API Configuration (deprecated - use TranslationApiConfig instead)
  @Deprecated('Use TranslationApiConfig.baseUrl instead')
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.translate.example.com',
  );
  
  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableLogging = true;
  
  // App Settings
  static const int maxHistoryItems = 100;
  static const int translationCacheDuration = 3600; // seconds
}


