import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'dart:io';
import '../error/exceptions.dart' as app_exceptions;

class CameraControllerService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  
  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw app_exceptions.CameraException('No cameras available');
      }
      
      // Use the first available camera (usually back camera)
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      await _controller!.initialize();
      
      // Set flash mode to off by default
      await _controller!.setFlashMode(FlashMode.off);
    } catch (e) {
      throw app_exceptions.CameraException('Failed to initialize camera: $e');
    }
  }
  
  Future<Uint8List> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw app_exceptions.CameraException('Camera not initialized');
    }
    
    try {
      final image = await _controller!.takePicture();
      final bytes = await File(image.path).readAsBytes();
      return bytes;
    } catch (e) {
      throw app_exceptions.CameraException('Failed to capture image: $e');
    }
  }
  
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
  
  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) {
      throw app_exceptions.CameraException('No other camera available');
    }
    
    final currentIndex = _cameras!.indexOf(_controller!.description);
    final nextIndex = (currentIndex + 1) % _cameras!.length;
    
    await _controller?.dispose();
    _controller = CameraController(
      _cameras![nextIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    
    await _controller!.initialize();
    
    // Set flash mode to off by default
    await _controller!.setFlashMode(FlashMode.off);
  }
}

