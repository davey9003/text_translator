class TranslationRequestModel {
  final String text;
  final String sourceLanguage;
  final String targetLanguage;
  
  TranslationRequestModel({
    required this.text,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
    };
  }
}


