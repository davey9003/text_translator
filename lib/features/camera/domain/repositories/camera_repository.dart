import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/detected_text.dart';
import 'dart:typed_data';

abstract class CameraRepository {
  Future<Either<Failure, Uint8List>> captureImage();
  Future<Either<Failure, DetectedText>> detectText(Uint8List imageBytes);
  Future<Either<Failure, DetectedText>> processFrame(Uint8List frameBytes);
}


