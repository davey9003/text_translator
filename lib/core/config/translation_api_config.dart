/// Translation API Provider Types
enum TranslationProvider {
  libreTranslate,
  myMemory,
  googleCloud,
  custom,
}

/// Configuration for Translation API
class TranslationApiConfig {
  // Provider selection
  static const TranslationProvider provider = TranslationProvider.libreTranslate;
  
  // Base URLs for different providers
  static const String libreTranslateUrl = 'https://libretranslate.com';
  static const String myMemoryUrl = 'https://api.mymemory.translated.net';
  static const String googleCloudUrl = 'https://translation.googleapis.com/language/translate/v2';
  
  // Custom API URL (if using custom provider)
  static const String customApiUrl = String.fromEnvironment(
    'TRANSLATION_API_URL',
    defaultValue: 'https://api.translate.example.com',
  );
  
  // API Key (required for some providers)
  static const String apiKey = String.fromEnvironment('TRANSLATION_API_KEY');
  
  /// Get the base URL based on selected provider
  static String get baseUrl {
    switch (provider) {
      case TranslationProvider.libreTranslate:
        return libreTranslateUrl;
      case TranslationProvider.myMemory:
        return myMemoryUrl;
      case TranslationProvider.googleCloud:
        return googleCloudUrl;
      case TranslationProvider.custom:
        return customApiUrl;
    }
  }
  
  /// Check if API key is required
  static bool get requiresApiKey {
    return provider == TranslationProvider.googleCloud ||
           provider == TranslationProvider.custom;
  }
  
  /// Check if API key is configured
  static bool get hasApiKey {
    return apiKey.isNotEmpty;
  }
}










