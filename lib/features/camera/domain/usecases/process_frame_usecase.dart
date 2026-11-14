import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/detected_text.dart';
import '../repositories/camera_repository.dart';
import 'dart:typed_data';

class ProcessFrameUseCase implements UseCase<DetectedText, Uint8List> {
  final CameraRepository repository;
  
  ProcessFrameUseCase(this.repository);
  
  @override
  Future<Either<Failure, DetectedText>> call(Uint8List frameBytes) async {
    return await repository.processFrame(frameBytes);
  }
}


