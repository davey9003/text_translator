import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import '../constants/supported_languages.dart';
import '../error/exceptions.dart';
import 'translation_model_service.dart';

abstract class TranslationService {
  Future<String> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });

  Future<String> detectLanguage(String text);

  Future<void> dispose();
}

class TranslationServiceImpl implements TranslationService {
  final TranslationModelService _modelService;
  final LanguageIdentifier _languageIdentifier;
  final Map<String, OnDeviceTranslator> _translators = {};

  TranslationServiceImpl({
    required TranslationModelService modelService,
    LanguageIdentifier? languageIdentifier,
  })  : _modelService = modelService,
        _languageIdentifier = languageIdentifier ??
            LanguageIdentifier(confidenceThreshold: 0.5);

  @override
  Future<String> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      if (text.trim().isEmpty) {
        return text;
      }

      final resolvedSource = await _resolveSourceLanguage(text, sourceLanguage);
      final resolvedTarget = SupportedLanguages.normalizeCode(targetLanguage);

      if (!SupportedLanguages.isSupported(resolvedSource)) {
        throw TranslationException(
          'Unsupported source language: $resolvedSource',
        );
      }
      if (!SupportedLanguages.isSupported(resolvedTarget)) {
        throw TranslationException(
          'Unsupported target language: $resolvedTarget',
        );
      }

      if (resolvedSource == resolvedTarget) {
        return text;
      }

      await _ensureModelsDownloaded([resolvedSource, resolvedTarget]);

      final sourceLang = _toTranslateLanguage(resolvedSource);
      final targetLang = _toTranslateLanguage(resolvedTarget);
      if (sourceLang == null || targetLang == null) {
        throw TranslationException(
          'Unsupported language pair: $resolvedSource -> $resolvedTarget',
        );
      }

      final translatorKey = '${sourceLang.bcpCode}_${targetLang.bcpCode}';
      var translator = _translators[translatorKey];
      if (translator == null) {
        translator = OnDeviceTranslator(
          sourceLanguage: sourceLang,
          targetLanguage: targetLang,
        );
        _translators[translatorKey] = translator;
      }

      return translator.translateText(text);
    } on AppException {
      rethrow;
    } catch (e) {
      throw TranslationException('Translation failed: $e');
    }
  }

  Future<String> _resolveSourceLanguage(String text, String sourceLanguage) async {
    final normalized = SupportedLanguages.normalizeCode(sourceLanguage);
    if (normalized == 'auto' || normalized.isEmpty) {
      return detectLanguage(text);
    }
    return normalized;
  }

  Future<void> _ensureModelsDownloaded(List<String> languageCodes) async {
    final uniqueCodes = languageCodes.toSet().toList();
    final missing = <String>[];
    for (final code in uniqueCodes) {
      if (!await _modelService.isDownloaded(code)) {
        missing.add(code);
      }
    }
    if (missing.isEmpty) {
      return;
    }

    final names = missing.map(SupportedLanguages.displayName).join(', ');
    throw MissingLanguageModelException(
      'Language model${missing.length == 1 ? '' : 's'} not downloaded: $names. '
      'Download ${missing.length == 1 ? 'it' : 'them'} from Language models.',
      missing,
    );
  }

  TranslateLanguage? _toTranslateLanguage(String langCode) {
    final normalized = SupportedLanguages.normalizeCode(langCode);
    if (normalized == 'auto' || normalized.isEmpty) {
      return null;
    }
    for (final language in TranslateLanguage.values) {
      if (language.bcpCode == normalized) {
        return language;
      }
    }
    return null;
  }

  @override
  Future<String> detectLanguage(String text) async {
    try {
      if (text.trim().isEmpty) {
        return 'en';
      }

      final identified = await _languageIdentifier.identifyLanguage(text);
      final normalized = SupportedLanguages.normalizeCode(identified);
      if (normalized == 'und' || !SupportedLanguages.isSupported(normalized)) {
        return 'en';
      }
      return normalized;
    } catch (_) {
      return 'en';
    }
  }

  @override
  Future<void> dispose() async {
    for (final translator in _translators.values) {
      await translator.close();
    }
    _translators.clear();
    await _languageIdentifier.close();
  }
}
