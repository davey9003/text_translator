import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/translation.dart';
import '../../domain/usecases/get_translation_history_usecase.dart';
import '../../domain/usecases/save_translation_usecase.dart';
import '../../domain/usecases/delete_translation_usecase.dart';
import '../../../../core/base/base_usecase.dart';

class HistoryProvider extends StateNotifier<HistoryState> {
  final GetTranslationHistoryUseCase getHistoryUseCase;
  final SaveTranslationUseCase saveTranslationUseCase;
  final DeleteTranslationUseCase deleteTranslationUseCase;
  
  HistoryProvider({
    required this.getHistoryUseCase,
    required this.saveTranslationUseCase,
    required this.deleteTranslationUseCase,
  }) : super(HistoryState.initial());
  
  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await getHistoryUseCase(NoParams());
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (history) {
        state = state.copyWith(
          isLoading: false,
          translations: history,
          error: null,
        );
      },
    );
  }
  
  Future<void> saveTranslation(Translation translation) async {
    final result = await saveTranslationUseCase(translation);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (_) {
        loadHistory(); // Reload history
      },
    );
  }
  
  Future<void> deleteTranslation(String id) async {
    final result = await deleteTranslationUseCase(id);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (_) {
        loadHistory(); // Reload history
      },
    );
  }
}

class HistoryState {
  final bool isLoading;
  final String? error;
  final List<Translation> translations;
  
  HistoryState({
    required this.isLoading,
    this.error,
    required this.translations,
  });
  
  factory HistoryState.initial() {
    return HistoryState(isLoading: false, translations: []);
  }
  
  HistoryState copyWith({
    bool? isLoading,
    String? error,
    List<Translation>? translations,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      translations: translations ?? this.translations,
    );
  }
}


