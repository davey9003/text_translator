import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/app_constants.dart';

class CheckFirstLaunchUseCase implements UseCase<bool, NoParams> {
  final StorageService storageService;
  
  CheckFirstLaunchUseCase(this.storageService);
  
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final firstLaunch = await storageService.get<bool>(AppConstants.firstLaunchKey);
      return Right(firstLaunch ?? true);
    } catch (e) {
      return const Right(true); // Default to first launch on error
    }
  }
}


