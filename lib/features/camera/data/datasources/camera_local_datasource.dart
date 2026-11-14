import 'dart:typed_data';
import '../../../../core/services/camera_service.dart';
import '../../../../core/error/exceptions.dart';

abstract class CameraLocalDataSource {
  Future<Uint8List> captureImage();
}

class CameraLocalDataSourceImpl implements CameraLocalDataSource {
  final CameraService cameraService;
  
  CameraLocalDataSourceImpl(this.cameraService);
  
  @override
  Future<Uint8List> captureImage() async {
    try {
      return await cameraService.captureImage();
    } catch (e) {
      throw CameraException('Failed to capture image: $e');
    }
  }
}


