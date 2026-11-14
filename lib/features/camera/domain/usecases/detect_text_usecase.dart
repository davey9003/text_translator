import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/detected_text.dart';
import '../repositories/camera_repository.dart';
import 'dart:typed_data';

class DetectTextUseCase implements UseCase<DetectedText, Uint8List> {
  final CameraRepository repository;
  
  DetectTextUseCase(this.repository);
  
  @override
  Future<Either<Failure, DetectedText>> call(Uint8List imageBytes) async {
    return await repository.detectText(imageBytes);
  }
}


