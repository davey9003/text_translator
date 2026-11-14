import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/translation_repository.dart';

class DetectLanguageUseCase implements UseCase<String, String> {
  final TranslationRepository repository;
  
  DetectLanguageUseCase(this.repository);
  
  @override
  Future<Either<Failure, String>> call(String text) async {
    return await repository.detectLanguage(text);
  }
}


