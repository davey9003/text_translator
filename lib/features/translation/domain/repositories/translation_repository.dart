import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/translation.dart';

abstract class TranslationRepository {
  Future<Either<Failure, Translation>> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });
  
  Future<Either<Failure, String>> detectLanguage(String text);
}


