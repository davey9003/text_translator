import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/app_settings.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  
  SettingsRepositoryImpl(this.localDataSource);
  
  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateSettings(AppSettings settings) async {
    try {
      final model = AppSettingsModel.fromEntity(settings);
      await localDataSource.saveSettings(model);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
}


