import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/camera_repository.dart';
import 'dart:typed_data';

class CaptureImageUseCase implements UseCase<Uint8List, NoParams> {
  final CameraRepository repository;
  
  CaptureImageUseCase(this.repository);
  
  @override
  Future<Either<Failure, Uint8List>> call(NoParams params) async {
    return await repository.captureImage();
  }
}


