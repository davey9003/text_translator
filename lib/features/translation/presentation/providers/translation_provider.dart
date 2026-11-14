import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../domain/entities/translation.dart';
import '../../domain/usecases/translate_text_usecase.dart';
import '../../domain/usecases/detect_language_usecase.dart';

// Riverpod provider
final translationProvider =
    StateNotifierProvider<TranslationProvider, TranslationState>((ref) {
      return TranslationProvider(
        translateTextUseCase: di.sl<TranslateTextUseCase>(),
        detectLanguageUseCase: di.sl<DetectLanguageUseCase>(),
      );
    });

class TranslationProvider extends StateNotifier<TranslationState> {
  final TranslateTextUseCase translateTextUseCase;
  final DetectLanguageUseCase detectLanguageUseCase;

  TranslationProvider({
    required this.translateTextUseCase,
    required this.detectLanguageUseCase,
  }) : super(TranslationState.initial());

  Future<void> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      clearTranslation: true,
    );

    final params = TranslateTextParams(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    final result = await translateTextUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (translation) {
        state = state.copyWith(
          isLoading: false,
          translation: translation,
          error: null,
        );
      },
    );
  }

  Future<void> detectLanguage(String text) async {
    final result = await detectLanguageUseCase(text);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (language) {
        state = state.copyWith(detectedLanguage: language);
      },
    );
  }

  void clearTranslation() {
    state = state.copyWith(clearTranslation: true, error: null);
  }
}

class TranslationState {
  final bool isLoading;
  final String? error;
  final Translation? translation;
  final String? detectedLanguage;

  TranslationState({
    required this.isLoading,
    this.error,
    this.translation,
    this.detectedLanguage,
  });

  factory TranslationState.initial() {
    return TranslationState(isLoading: false);
  }

  TranslationState copyWith({
    bool? isLoading,
    String? error,
    Translation? translation,
    String? detectedLanguage,
    bool clearTranslation = false,
  }) {
    return TranslationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      translation: clearTranslation ? null : translation ?? this.translation,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
    );
  }
}
