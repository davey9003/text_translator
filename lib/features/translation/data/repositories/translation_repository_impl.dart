import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/translation_service.dart';
import '../../domain/repositories/translation_repository.dart';
import '../../domain/entities/translation.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationService translationService;

  TranslationRepositoryImpl(this.translationService);

  @override
  Future<Either<Failure, Translation>> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      var resolvedSource = sourceLanguage;
      if (sourceLanguage == 'auto' || sourceLanguage.isEmpty) {
        resolvedSource = await translationService.detectLanguage(text);
      }

      final translatedText = await translationService.translate(
        text: text,
        sourceLanguage: resolvedSource,
        targetLanguage: targetLanguage,
      );

      return Right(
        Translation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          originalText: text,
          translatedText: translatedText,
          sourceLanguage: resolvedSource,
          targetLanguage: targetLanguage,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> detectLanguage(String text) async {
    try {
      final language = await translationService.detectLanguage(text);
      return Right(language);
    } catch (e) {
      return Left(ErrorHandler.mapExceptionToFailure(e));
    }
  }
}
