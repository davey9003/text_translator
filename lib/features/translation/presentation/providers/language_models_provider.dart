import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/supported_languages.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/translation_model_service.dart';
import '../../domain/entities/language.dart';

final languageModelsProvider =
    StateNotifierProvider<LanguageModelsNotifier, LanguageModelsState>((ref) {
  return LanguageModelsNotifier(di.sl<TranslationModelService>());
});

class LanguageModelsNotifier extends StateNotifier<LanguageModelsState> {
  final TranslationModelService _modelService;

  LanguageModelsNotifier(this._modelService)
      : super(LanguageModelsState.initial()) {
    refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final codes = SupportedLanguages.all.map((language) => language.code);
      final statuses = await _modelService.statusFor(codes);
      state = state.copyWith(
        isLoading: false,
        downloaded: statuses,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> download(String languageCode) async {
    final code = SupportedLanguages.normalizeCode(languageCode);
    state = state.copyWith(
      downloading: {...state.downloading, code},
      error: null,
      itemErrors: {...state.itemErrors}..remove(code),
    );

    try {
      await _modelService.download(code);
      final downloaded = Map<String, bool>.from(state.downloaded)..[code] = true;
      final downloading = Set<String>.from(state.downloading)..remove(code);
      state = state.copyWith(downloaded: downloaded, downloading: downloading);
      return true;
    } catch (e) {
      final downloading = Set<String>.from(state.downloading)..remove(code);
      state = state.copyWith(
        downloading: downloading,
        itemErrors: {...state.itemErrors, code: e.toString()},
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> downloadMany(Iterable<String> languageCodes) async {
    var allSucceeded = true;
    for (final code in languageCodes.toSet()) {
      final success = await download(code);
      if (!success) {
        allSucceeded = false;
      }
    }
    return allSucceeded;
  }

  Future<bool> delete(String languageCode) async {
    final code = SupportedLanguages.normalizeCode(languageCode);
    try {
      await _modelService.delete(code);
      final downloaded = Map<String, bool>.from(state.downloaded)..[code] = false;
      state = state.copyWith(downloaded: downloaded);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

class LanguageModelsState {
  final bool isLoading;
  final String? error;
  final Map<String, bool> downloaded;
  final Set<String> downloading;
  final Map<String, String> itemErrors;

  LanguageModelsState({
    required this.isLoading,
    this.error,
    required this.downloaded,
    required this.downloading,
    required this.itemErrors,
  });

  factory LanguageModelsState.initial() {
    return LanguageModelsState(
      isLoading: true,
      downloaded: const {},
      downloading: const {},
      itemErrors: const {},
    );
  }

  bool isDownloaded(String code) =>
      downloaded[SupportedLanguages.normalizeCode(code)] ?? false;

  bool isDownloading(String code) =>
      downloading.contains(SupportedLanguages.normalizeCode(code));

  List<Language> get downloadedLanguages => SupportedLanguages.all
      .where((language) => isDownloaded(language.code))
      .toList();

  LanguageModelsState copyWith({
    bool? isLoading,
    String? error,
    Map<String, bool>? downloaded,
    Set<String>? downloading,
    Map<String, String>? itemErrors,
  }) {
    return LanguageModelsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      downloaded: downloaded ?? this.downloaded,
      downloading: downloading ?? this.downloading,
      itemErrors: itemErrors ?? this.itemErrors,
    );
  }
}
