import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/base/base_usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';

// Riverpod provider
final settingsProvider = StateNotifierProvider<SettingsProvider, SettingsState>((ref) {
  return SettingsProvider(
    getSettingsUseCase: di.sl<GetSettingsUseCase>(),
    updateSettingsUseCase: di.sl<UpdateSettingsUseCase>(),
  );
});

class SettingsProvider extends StateNotifier<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;
  
  SettingsProvider({
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
  }) : super(SettingsState.initial());
  
  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await getSettingsUseCase(NoParams());
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (settings) {
        state = state.copyWith(
          isLoading: false,
          settings: settings,
          error: null,
        );
      },
    );
  }
  
  Future<void> updateSettings(AppSettings settings) async {
    final result = await updateSettingsUseCase(settings);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (_) {
        state = state.copyWith(settings: settings);
      },
    );
  }
}

class SettingsState {
  final bool isLoading;
  final String? error;
  final AppSettings? settings;
  
  SettingsState({
    required this.isLoading,
    this.error,
    this.settings,
  });
  
  factory SettingsState.initial() {
    return SettingsState(isLoading: false);
  }
  
  SettingsState copyWith({
    bool? isLoading,
    String? error,
    AppSettings? settings,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      settings: settings ?? this.settings,
    );
  }
}


