import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  AppSettingsModel({
    required super.defaultSourceLanguage,
    required super.defaultTargetLanguage,
    required super.isDarkMode,
    required super.enableNotifications,
    required super.enableAutoDetect,
  });
  
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      defaultSourceLanguage: json['defaultSourceLanguage'] as String? ?? 'en', // Default source language
      defaultTargetLanguage: json['defaultTargetLanguage'] as String? ?? 'en', // English as default target
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableAutoDetect: json['enableAutoDetect'] as bool? ?? false, // ML Kit Translation doesn't support auto-detect
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'defaultSourceLanguage': defaultSourceLanguage,
      'defaultTargetLanguage': defaultTargetLanguage,
      'isDarkMode': isDarkMode,
      'enableNotifications': enableNotifications,
      'enableAutoDetect': enableAutoDetect,
    };
  }
  
  factory AppSettingsModel.fromEntity(AppSettings settings) {
    return AppSettingsModel(
      defaultSourceLanguage: settings.defaultSourceLanguage,
      defaultTargetLanguage: settings.defaultTargetLanguage,
      isDarkMode: settings.isDarkMode,
      enableNotifications: settings.enableNotifications,
      enableAutoDetect: settings.enableAutoDetect,
    );
  }
  
  factory AppSettingsModel.defaultSettings() {
    return AppSettingsModel(
      defaultSourceLanguage: 'en', // Default source language (ML Kit doesn't support auto-detect)
      defaultTargetLanguage: 'en', // English as default target
      isDarkMode: false,
      enableNotifications: true,
      enableAutoDetect: false, // ML Kit Translation doesn't support auto-detect
    );
  }
}

