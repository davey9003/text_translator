import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../services/ml_kit_service.dart';
import '../services/translation_service.dart';
import '../services/translation_model_service.dart';
import '../services/camera_service.dart';
import '../services/camera_controller_service.dart';
import '../services/storage_service.dart';
import '../services/permission_service.dart';
import '../services/analytics_service.dart';
import '../services/crash_reporting_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../config/translation_api_config.dart';

// Camera feature
import '../../features/camera/data/datasources/camera_local_datasource.dart';
import '../../features/camera/data/datasources/ml_kit_datasource.dart';
import '../../features/camera/data/repositories/camera_repository_impl.dart';
import '../../features/camera/domain/repositories/camera_repository.dart';
import '../../features/camera/domain/usecases/capture_image_usecase.dart';
import '../../features/camera/domain/usecases/detect_text_usecase.dart';
import '../../features/camera/domain/usecases/process_frame_usecase.dart';

// Translation feature
import '../../features/translation/data/datasources/translation_remote_datasource.dart';
import '../../features/translation/data/datasources/translation_local_datasource.dart';
import '../../features/translation/data/repositories/translation_repository_impl.dart';
import '../../features/translation/data/repositories/history_repository_impl.dart';
import '../../features/translation/domain/repositories/translation_repository.dart';
import '../../features/translation/domain/repositories/history_repository.dart';
import '../../features/translation/domain/usecases/translate_text_usecase.dart';
import '../../features/translation/domain/usecases/detect_language_usecase.dart';
import '../../features/translation/domain/usecases/get_translation_history_usecase.dart';
import '../../features/translation/domain/usecases/save_translation_usecase.dart';
import '../../features/translation/domain/usecases/delete_translation_usecase.dart';

// Settings feature
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings_usecase.dart';
import '../../features/settings/domain/usecases/update_settings_usecase.dart';

// Onboarding
import '../../features/onboarding/domain/usecases/check_first_launch_usecase.dart';
import '../../features/onboarding/domain/usecases/complete_first_launch_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      client: sl(),
      baseUrl: TranslationApiConfig.baseUrl,
    ),
  );
  
  // Services
  sl.registerLazySingleton<MLKitService>(() => MLKitServiceImpl());
  sl.registerLazySingleton<TranslationModelService>(
    () => TranslationModelServiceImpl(),
  );
  sl.registerLazySingleton<TranslationService>(
    () => TranslationServiceImpl(modelService: sl()),
  );
  sl.registerLazySingleton<CameraControllerService>(
    () => CameraControllerService(),
  );
  sl.registerLazySingleton<CameraService>(
    () => CameraServiceImpl(sl()),
  );
  sl.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(sl()),
  );
  sl.registerLazySingleton<PermissionService>(
    () => PermissionServiceImpl(),
  );
  sl.registerLazySingleton<AnalyticsService>(
    () => AnalyticsServiceImpl(),
  );
  sl.registerLazySingleton<CrashReportingService>(
    () => CrashReportingServiceImpl(),
  );
  
  // Camera Feature - Data Sources
  sl.registerLazySingleton<CameraLocalDataSource>(
    () => CameraLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MLKitDataSource>(
    () => MLKitDataSourceImpl(sl()),
  );
  
  // Camera Feature - Repositories
  sl.registerLazySingleton<CameraRepository>(
    () => CameraRepositoryImpl(
      cameraDataSource: sl(),
      mlKitDataSource: sl(),
    ),
  );
  
  // Camera Feature - Use Cases
  sl.registerLazySingleton(() => CaptureImageUseCase(sl()));
  sl.registerLazySingleton(() => DetectTextUseCase(sl()));
  sl.registerLazySingleton(() => ProcessFrameUseCase(sl()));
  
  // Translation Feature - Data Sources
  sl.registerLazySingleton<TranslationRemoteDataSource>(
    () => TranslationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TranslationLocalDataSource>(
    () => TranslationLocalDataSourceImpl(sl()),
  );
  
  // Translation Feature - Repositories
  sl.registerLazySingleton<TranslationRepository>(
    () => TranslationRepositoryImpl(sl<TranslationService>()),
  );
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(sl()),
  );
  
  // Translation Feature - Use Cases
  sl.registerLazySingleton(() => TranslateTextUseCase(sl()));
  sl.registerLazySingleton(() => DetectLanguageUseCase(sl()));
  sl.registerLazySingleton(() => GetTranslationHistoryUseCase(sl()));
  sl.registerLazySingleton(() => SaveTranslationUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTranslationUseCase(sl()));
  
  // Settings Feature - Data Sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );
  
  // Settings Feature - Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  
  // Settings Feature - Use Cases
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(sl()));

  // Onboarding
  sl.registerLazySingleton(() => CheckFirstLaunchUseCase(sl()));
  sl.registerLazySingleton(() => CompleteFirstLaunchUseCase(sl()));
}


