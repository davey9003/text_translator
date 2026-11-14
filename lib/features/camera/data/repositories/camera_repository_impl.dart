import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/repositories/camera_repository.dart';
import '../../domain/entities/detected_text.dart';
import '../datasources/camera_local_datasource.dart';
import '../datasources/ml_kit_datasource.dart';
import 'dart:typed_data';

class CameraRepositoryImpl implements CameraRepository {
  final CameraLocalDataSource cameraDataSource;
  final MLKitDataSource mlKitDataSource;
  
  CameraRepositoryImpl({
    required this.cameraDataSource,
    required this.mlKitDataSource,
  });
  
  @override
  Future<Either<Failure, Uint8List>> captureImage() async {
    try {
      final imageBytes = await cameraDataSource.captureImage();
      return Right(imageBytes);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
  
  @override
  Future<Either<Failure, DetectedText>> detectText(Uint8List imageBytes) async {
    try {
      final detectedText = await mlKitDataSource.detectText(imageBytes);
      return Right(detectedText);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
  
  @override
  Future<Either<Failure, DetectedText>> processFrame(Uint8List frameBytes) async {
    try {
      final detectedText = await mlKitDataSource.detectText(frameBytes);
      return Right(detectedText);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
}


