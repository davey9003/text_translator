import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/routes/route_names.dart';
import 'core/base/base_usecase.dart';
import 'features/onboarding/domain/usecases/check_first_launch_usecase.dart';
import 'core/di/service_locator.dart' as di;
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  final isFirstLaunch = await di.sl<CheckFirstLaunchUseCase>()(NoParams());
  final initialLocation = isFirstLaunch.fold(
    (_) => RouteNames.onboarding,
    (firstLaunch) => firstLaunch ? RouteNames.onboarding : RouteNames.camera,
  );

  runApp(ProviderScope(child: App(initialLocation: initialLocation)));
}
