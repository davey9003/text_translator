import 'dart:typed_data';
import 'camera_controller_service.dart';
import '../error/exceptions.dart';

abstract class CameraService {
  Future<Uint8List> captureImage();
  Future<void> initialize();
  Future<void> dispose();
  CameraControllerService? get controllerService;
}

class CameraServiceImpl implements CameraService {
  final CameraControllerService _controllerService;
  
  CameraServiceImpl(this._controllerService);
  
  @override
  CameraControllerService? get controllerService => _controllerService;
  
  @override
  Future<Uint8List> captureImage() async {
    try {
      return await _controllerService.captureImage();
    } catch (e) {
      throw CameraException('Failed to capture image: $e');
    }
  }
  
  @override
  Future<void> initialize() async {
    try {
      await _controllerService.initialize();
    } catch (e) {
      throw CameraException('Failed to initialize camera: $e');
    }
  }
  
  @override
  Future<void> dispose() async {
    try {
      await _controllerService.dispose();
    } catch (e) {
      throw CameraException('Failed to dispose camera: $e');
    }
  }
}


