import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase implements UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;
  
  GetSettingsUseCase(this.repository);
  
  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    return await repository.getSettings();
  }
}


