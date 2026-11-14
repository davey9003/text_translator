import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes/app_router.dart';
import 'routes/route_names.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key, this.initialLocation = RouteNames.camera});

  final String initialLocation;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.create(initialLocation: widget.initialLocation);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lens Translate',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
