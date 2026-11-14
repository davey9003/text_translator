import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/translation.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<Translation>>> getTranslationHistory();
  Future<Either<Failure, void>> saveTranslation(Translation translation);
  Future<Either<Failure, void>> deleteTranslation(String id);
  Future<Either<Failure, void>> clearHistory();
}


