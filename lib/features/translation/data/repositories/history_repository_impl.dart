import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/entities/translation.dart';
import '../datasources/translation_local_datasource.dart';
import '../models/translation_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final TranslationLocalDataSource localDataSource;
  
  HistoryRepositoryImpl(this.localDataSource);
  
  @override
  Future<Either<Failure, List<Translation>>> getTranslationHistory() async {
    try {
      final history = await localDataSource.getHistory();
      return Right(history);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveTranslation(Translation translation) async {
    try {
      final model = TranslationModel.fromEntity(translation);
      await localDataSource.saveTranslation(model);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteTranslation(String id) async {
    try {
      await localDataSource.deleteTranslation(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
  
  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e as Exception));
    }
  }
}


