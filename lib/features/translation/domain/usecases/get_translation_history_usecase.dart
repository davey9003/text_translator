import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/translation.dart';
import '../repositories/history_repository.dart';

class GetTranslationHistoryUseCase implements UseCase<List<Translation>, NoParams> {
  final HistoryRepository repository;
  
  GetTranslationHistoryUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Translation>>> call(NoParams params) async {
    return await repository.getTranslationHistory();
  }
}


