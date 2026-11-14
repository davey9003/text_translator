import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateSettingsUseCase implements UseCase<void, AppSettings> {
  final SettingsRepository repository;
  
  UpdateSettingsUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(AppSettings settings) async {
    return await repository.updateSettings(settings);
  }
}


