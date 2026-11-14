import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/translation.dart';
import '../repositories/translation_repository.dart';

class TranslateTextParams {
  final String text;
  final String sourceLanguage;
  final String targetLanguage;
  
  TranslateTextParams({
    required this.text,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}

class TranslateTextUseCase implements UseCase<Translation, TranslateTextParams> {
  final TranslationRepository repository;
  
  TranslateTextUseCase(this.repository);
  
  @override
  Future<Either<Failure, Translation>> call(TranslateTextParams params) async {
    return await repository.translateText(
      text: params.text,
      sourceLanguage: params.sourceLanguage,
      targetLanguage: params.targetLanguage,
    );
  }
}


