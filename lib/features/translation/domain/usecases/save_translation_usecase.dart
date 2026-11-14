import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/translation.dart';
import '../repositories/history_repository.dart';

class SaveTranslationUseCase implements UseCase<void, Translation> {
  final HistoryRepository repository;
  
  SaveTranslationUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(Translation translation) async {
    return await repository.saveTranslation(translation);
  }
}


