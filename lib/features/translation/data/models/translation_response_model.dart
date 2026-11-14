import '../../domain/entities/translation.dart';
import 'translation_model.dart';

class TranslationResponseModel {
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  
  TranslationResponseModel({
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
  
  factory TranslationResponseModel.fromJson(Map<String, dynamic> json) {
    return TranslationResponseModel(
      translatedText: json['translatedText'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
    );
  }
  
  Translation toEntity(String originalText) {
    return TranslationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalText: originalText,
      translatedText: translatedText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      createdAt: DateTime.now(),
    );
  }
}


