import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import '../constants/supported_languages.dart';
import '../error/exceptions.dart';

abstract class TranslationModelService {
  Future<bool> isDownloaded(String languageCode);
  Future<void> download(String languageCode, {bool isWifiRequired = false});
  Future<void> delete(String languageCode);
  Future<Map<String, bool>> statusFor(Iterable<String> languageCodes);
}

class TranslationModelServiceImpl implements TranslationModelService {
  final OnDeviceTranslatorModelManager _modelManager;

  TranslationModelServiceImpl({OnDeviceTranslatorModelManager? modelManager})
      : _modelManager = modelManager ?? OnDeviceTranslatorModelManager();

  @override
  Future<bool> isDownloaded(String languageCode) async {
    final code = SupportedLanguages.normalizeCode(languageCode);
    if (!SupportedLanguages.isSupported(code)) {
      return false;
    }
    return _modelManager.isModelDownloaded(code);
  }

  @override
  Future<void> download(
    String languageCode, {
    bool isWifiRequired = false,
  }) async {
    final code = SupportedLanguages.normalizeCode(languageCode);
    if (!SupportedLanguages.isSupported(code)) {
      throw TranslationException('Unsupported language: $languageCode');
    }

    final success = await _modelManager.downloadModel(
      code,
      isWifiRequired: isWifiRequired,
    );
    if (!success) {
      throw TranslationException(
        'Failed to download the ${SupportedLanguages.displayName(code)} model. '
        'Check your internet connection and try again.',
      );
    }
  }

  @override
  Future<void> delete(String languageCode) async {
    final code = SupportedLanguages.normalizeCode(languageCode);
    if (!SupportedLanguages.isSupported(code)) {
      throw TranslationException('Unsupported language: $languageCode');
    }
    await _modelManager.deleteModel(code);
  }

  @override
  Future<Map<String, bool>> statusFor(Iterable<String> languageCodes) async {
    final statuses = <String, bool>{};
    for (final code in languageCodes) {
      final normalized = SupportedLanguages.normalizeCode(code);
      statuses[normalized] = await isDownloaded(normalized);
    }
    return statuses;
  }
}
