import '../../features/translation/domain/entities/language.dart';

/// Languages supported by on-device ML Kit Translation.
class SupportedLanguages {
  static const List<Language> all = [
    Language(code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans'),
    Language(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
    Language(code: 'be', name: 'Belarusian', nativeName: 'Беларуская'),
    Language(code: 'bg', name: 'Bulgarian', nativeName: 'Български'),
    Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা'),
    Language(code: 'ca', name: 'Catalan', nativeName: 'Català'),
    Language(code: 'cs', name: 'Czech', nativeName: 'Čeština'),
    Language(code: 'cy', name: 'Welsh', nativeName: 'Cymraeg'),
    Language(code: 'da', name: 'Danish', nativeName: 'Dansk'),
    Language(code: 'de', name: 'German', nativeName: 'Deutsch'),
    Language(code: 'el', name: 'Greek', nativeName: 'Ελληνικά'),
    Language(code: 'en', name: 'English', nativeName: 'English'),
    Language(code: 'eo', name: 'Esperanto', nativeName: 'Esperanto'),
    Language(code: 'es', name: 'Spanish', nativeName: 'Español'),
    Language(code: 'et', name: 'Estonian', nativeName: 'Eesti'),
    Language(code: 'fa', name: 'Persian', nativeName: 'فارسی'),
    Language(code: 'fi', name: 'Finnish', nativeName: 'Suomi'),
    Language(code: 'fr', name: 'French', nativeName: 'Français'),
    Language(code: 'ga', name: 'Irish', nativeName: 'Gaeilge'),
    Language(code: 'gl', name: 'Galician', nativeName: 'Galego'),
    Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી'),
    Language(code: 'he', name: 'Hebrew', nativeName: 'עברית'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    Language(code: 'hr', name: 'Croatian', nativeName: 'Hrvatski'),
    Language(code: 'ht', name: 'Haitian Creole', nativeName: 'Kreyòl ayisyen'),
    Language(code: 'hu', name: 'Hungarian', nativeName: 'Magyar'),
    Language(code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia'),
    Language(code: 'is', name: 'Icelandic', nativeName: 'Íslenska'),
    Language(code: 'it', name: 'Italian', nativeName: 'Italiano'),
    Language(code: 'ja', name: 'Japanese', nativeName: '日本語'),
    Language(code: 'ka', name: 'Georgian', nativeName: 'ქართული'),
    Language(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    Language(code: 'ko', name: 'Korean', nativeName: '한국어'),
    Language(code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių'),
    Language(code: 'lv', name: 'Latvian', nativeName: 'Latviešu'),
    Language(code: 'mk', name: 'Macedonian', nativeName: 'Македонски'),
    Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
    Language(code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu'),
    Language(code: 'mt', name: 'Maltese', nativeName: 'Malti'),
    Language(code: 'nl', name: 'Dutch', nativeName: 'Nederlands'),
    Language(code: 'no', name: 'Norwegian', nativeName: 'Norsk'),
    Language(code: 'pl', name: 'Polish', nativeName: 'Polski'),
    Language(code: 'pt', name: 'Portuguese', nativeName: 'Português'),
    Language(code: 'ro', name: 'Romanian', nativeName: 'Română'),
    Language(code: 'ru', name: 'Russian', nativeName: 'Русский'),
    Language(code: 'sk', name: 'Slovak', nativeName: 'Slovenčina'),
    Language(code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina'),
    Language(code: 'sq', name: 'Albanian', nativeName: 'Shqip'),
    Language(code: 'sv', name: 'Swedish', nativeName: 'Svenska'),
    Language(code: 'sw', name: 'Swahili', nativeName: 'Kiswahili'),
    Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    Language(code: 'th', name: 'Thai', nativeName: 'ไทย'),
    Language(code: 'tl', name: 'Tagalog', nativeName: 'Tagalog'),
    Language(code: 'tr', name: 'Turkish', nativeName: 'Türkçe'),
    Language(code: 'uk', name: 'Ukrainian', nativeName: 'Українська'),
    Language(code: 'ur', name: 'Urdu', nativeName: 'اردو'),
    Language(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt'),
    Language(code: 'zh', name: 'Chinese', nativeName: '中文'),
  ];

  static const List<String> recommendedSetupCodes = ['en', 'es'];

  static Language byCode(String code) {
    final normalized = normalizeCode(code);
    return all.firstWhere(
      (language) => language.code == normalized,
      orElse: () => Language(
        code: normalized,
        name: normalized.toUpperCase(),
        nativeName: normalized,
      ),
    );
  }

  static bool isSupported(String code) {
    final normalized = normalizeCode(code);
    return all.any((language) => language.code == normalized);
  }

  static String normalizeCode(String code) {
    final lower = code.trim().toLowerCase();
    if (lower == 'und' || lower.isEmpty || lower == 'auto') {
      return lower;
    }
    if (lower.startsWith('zh')) {
      return 'zh';
    }
    if (lower == 'iw') {
      return 'he';
    }
    if (lower == 'nb' || lower == 'nn') {
      return 'no';
    }
    return lower.split(RegExp(r'[-_]')).first;
  }

  static String displayName(String code) => byCode(code).name;
}
