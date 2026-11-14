class AppSettings {
  final String defaultSourceLanguage;
  final String defaultTargetLanguage;
  final bool isDarkMode;
  final bool enableNotifications;
  final bool enableAutoDetect;
  
  AppSettings({
    required this.defaultSourceLanguage,
    required this.defaultTargetLanguage,
    required this.isDarkMode,
    required this.enableNotifications,
    required this.enableAutoDetect,
  });
  
  AppSettings copyWith({
    String? defaultSourceLanguage,
    String? defaultTargetLanguage,
    bool? isDarkMode,
    bool? enableNotifications,
    bool? enableAutoDetect,
  }) {
    return AppSettings(
      defaultSourceLanguage: defaultSourceLanguage ?? this.defaultSourceLanguage,
      defaultTargetLanguage: defaultTargetLanguage ?? this.defaultTargetLanguage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableAutoDetect: enableAutoDetect ?? this.enableAutoDetect,
    );
  }
}


