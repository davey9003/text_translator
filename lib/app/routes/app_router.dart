import 'package:go_router/go_router.dart';
import '../../features/camera/presentation/pages/camera_page.dart';
import '../../features/translation/presentation/pages/translation_result_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/translation/presentation/pages/language_models_page.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter create({required String initialLocation}) => GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.camera,
        builder: (context, state) => const CameraPage(),
      ),
      GoRoute(
        path: RouteNames.translationResult,
        builder: (context, state) => const TranslationResultPage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.languageModels,
        builder: (context, state) => const LanguageModelsPage(),
      ),
    ],
  );
}
