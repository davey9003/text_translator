import '../../domain/entities/translation.dart';

class TranslationModel extends Translation {
  TranslationModel({
    required super.id,
    required super.originalText,
    required super.translatedText,
    required super.sourceLanguage,
    required super.targetLanguage,
    required super.createdAt,
  });
  
  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      id: json['id'] as String,
      originalText: json['originalText'] as String,
      translatedText: json['translatedText'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalText': originalText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory TranslationModel.fromEntity(Translation translation) {
    return TranslationModel(
      id: translation.id,
      originalText: translation.originalText,
      translatedText: translation.translatedText,
      sourceLanguage: translation.sourceLanguage,
      targetLanguage: translation.targetLanguage,
      createdAt: translation.createdAt,
    );
  }
}


