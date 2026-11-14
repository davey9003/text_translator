import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/history_repository.dart';

class DeleteTranslationUseCase implements UseCase<void, String> {
  final HistoryRepository repository;
  
  DeleteTranslationUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTranslation(id);
  }
}


