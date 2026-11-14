import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/storage_service.dart';

class CompleteFirstLaunchUseCase implements UseCase<void, NoParams> {
  final StorageService storageService;

  CompleteFirstLaunchUseCase(this.storageService);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await storageService.save(AppConstants.firstLaunchKey, false);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure('Failed to complete first launch: $e'));
    }
  }
}
