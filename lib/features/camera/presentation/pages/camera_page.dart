import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/camera_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/utils/helpers/permissions_helper.dart';
import '../../../../app/routes/route_names.dart';
import '../providers/camera_provider.dart';
import '../widgets/camera_controls.dart';
import '../widgets/camera_overlay.dart';
import '../../../translation/presentation/providers/translation_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  final CameraService _cameraService = di.sl<CameraService>();
  final PermissionService _permissionService = di.sl<PermissionService>();
  bool _isInitializing = true;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsNotifier = ref.read(settingsProvider.notifier);
    await settingsNotifier.loadSettings();
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _isInitializing = true;
        _initError = null;
      });

      // Request camera permission
      final permissionsHelper = PermissionsHelper(_permissionService);
      await permissionsHelper.ensureCameraPermission();

      // Initialize camera
      await _cameraService.initialize();
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _initError = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _handleCapture() async {
    try {
      // Step 1: Take a still picture and detect text
      final cameraNotifier = ref.read(cameraProvider.notifier);
      await cameraNotifier.captureAndDetect();

      // Step 2: Get the detected text from state
      final cameraState = ref.read(cameraProvider);

      // Step 3: If text was detected, translate it
      if (cameraState.detectedText != null &&
          cameraState.detectedText!.fullText.isNotEmpty) {
        await _translateDetectedText(cameraState.detectedText!.fullText);
      } else if (cameraState.error == null) {
        // No text detected but no error - show message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No text detected in the image'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _translateDetectedText(String text) async {
    final settingsState = ref.read(settingsProvider);
    final settings = settingsState.settings;

    if (settings == null) {
      // Load settings if not loaded
      await ref.read(settingsProvider.notifier).loadSettings();
      final updatedSettings = ref.read(settingsProvider).settings;
      if (updatedSettings == null) return;
    }

    final finalSettings = settings ?? ref.read(settingsProvider).settings;
    if (finalSettings == null) return;

    final translationNotifier = ref.read(translationProvider.notifier);
    await translationNotifier.translateText(
      text: text,
      sourceLanguage: finalSettings.enableAutoDetect
          ? 'auto'
          : finalSettings.defaultSourceLanguage,
      targetLanguage: finalSettings.defaultTargetLanguage,
    );
  }

  Future<void> _handleFlipCamera() async {
    try {
      final controllerService = _cameraService.controllerService;
      if (controllerService != null) {
        await controllerService.switchCamera();
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to switch camera: $e')));
      }
    }
  }

  Future<void> _handleGallery() async {
    // Gallery functionality - open image picker
    // For now, show a message that this feature will be implemented
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gallery feature coming soon')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);
    final translationState = ref.watch(translationProvider);
    final controllerService = _cameraService.controllerService;
    final controller = controllerService?.controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        actions: [
          IconButton(
            tooltip: 'Language models',
            icon: const Icon(Icons.language),
            onPressed: () => context.push(RouteNames.languageModels),
          ),
        ],
      ),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : _initError != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error initializing camera',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _initError!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _initializeCamera,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : controller == null || !controller.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Camera view with overlay
                Expanded(
                  child: Stack(
                    children: [
                      // Camera preview
                      Positioned.fill(child: CameraPreview(controller)),
                      // Overlay
                      const Positioned.fill(
                        child: Center(child: CameraOverlay()),
                      ),
                      // Loading indicator
                      if (cameraState.isLoading || translationState.isLoading)
                        const Center(child: CircularProgressIndicator()),
                      // Error message
                      if (cameraState.error != null)
                        Positioned(
                          top: 80,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cameraState.error!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      // Translation error message
                      if (translationState.error != null)
                        Positioned(
                          top: 80,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              translationState.error!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      // Controls
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                          child: CameraControls(
                            onCapture: _handleCapture,
                            onFlip: _handleFlipCamera,
                            onGallery: _handleGallery,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Translation text box
                if (translationState.translation != null ||
                    (cameraState.detectedText != null &&
                        cameraState.detectedText!.fullText.isNotEmpty))
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Detected text
                        if (cameraState.detectedText != null &&
                            cameraState.detectedText!.fullText.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detected Text:',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.color,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  cameraState.detectedText!.fullText,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        // Translated text
                        Text(
                          'Translation:',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                          ),
                          child: translationState.isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Text(
                                  translationState
                                          .translation
                                          ?.translatedText ??
                                      'Translating...',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),
                                ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
