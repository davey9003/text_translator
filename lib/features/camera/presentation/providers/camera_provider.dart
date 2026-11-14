import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../domain/entities/detected_text.dart';
import '../../domain/usecases/capture_image_usecase.dart';
import '../../domain/usecases/detect_text_usecase.dart';
import '../../domain/usecases/process_frame_usecase.dart';
import 'dart:typed_data';

// Riverpod provider
final cameraProvider = StateNotifierProvider<CameraProvider, CameraState>((ref) {
  return CameraProvider(
    captureImageUseCase: di.sl<CaptureImageUseCase>(),
    detectTextUseCase: di.sl<DetectTextUseCase>(),
    processFrameUseCase: di.sl<ProcessFrameUseCase>(),
  );
});

class CameraProvider extends StateNotifier<CameraState> {
  final CaptureImageUseCase captureImageUseCase;
  final DetectTextUseCase detectTextUseCase;
  final ProcessFrameUseCase processFrameUseCase;
  
  CameraProvider({
    required this.captureImageUseCase,
    required this.detectTextUseCase,
    required this.processFrameUseCase,
  }) : super(CameraState.initial());
  
  Future<void> captureAndDetect() async {
    // Clear previous detection
    state = state.copyWith(
      isLoading: true,
      error: null,
      detectedText: null,
    );
    
    // Step 1: Capture a still picture
    final imageResult = await captureImageUseCase(NoParams());
    
    await imageResult.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (imageBytes) async {
        // Step 2: Process the captured image for text detection
        final detectResult = await detectTextUseCase(imageBytes);
        detectResult.fold(
          (failure) {
            state = state.copyWith(
              isLoading: false,
              error: failure.message,
            );
          },
          (detectedText) {
            // Text detected successfully
            state = state.copyWith(
              isLoading: false,
              detectedText: detectedText,
              error: null,
            );
          },
        );
      },
    );
  }
  
  Future<void> processFrame(Uint8List frameBytes) async {
    final result = await processFrameUseCase(frameBytes);
    result.fold(
      (failure) {
        // Don't update state on frame processing errors to avoid flickering
      },
      (detectedText) {
        state = state.copyWith(detectedText: detectedText);
      },
    );
  }
  
  void clearDetectedText() {
    state = state.copyWith(detectedText: null);
  }
}

class CameraState {
  final bool isLoading;
  final bool isCameraInitialized;
  final String? error;
  final DetectedText? detectedText;
  
  CameraState({
    required this.isLoading,
    this.isCameraInitialized = false,
    this.error,
    this.detectedText,
  });
  
  factory CameraState.initial() {
    return CameraState(isLoading: false, isCameraInitialized: false);
  }
  
  CameraState copyWith({
    bool? isLoading,
    bool? isCameraInitialized,
    String? error,
    DetectedText? detectedText,
  }) {
    return CameraState(
      isLoading: isLoading ?? this.isLoading,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      error: error,
      detectedText: detectedText ?? this.detectedText,
    );
  }
}

