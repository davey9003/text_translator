import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/translation_request_model.dart';
import '../models/translation_response_model.dart';

abstract class TranslationRemoteDataSource {
  Future<TranslationResponseModel> translateText(TranslationRequestModel request);
  Future<String> detectLanguage(String text);
}

class TranslationRemoteDataSourceImpl implements TranslationRemoteDataSource {
  final ApiClient apiClient;
  
  TranslationRemoteDataSourceImpl(this.apiClient);
  
  @override
  Future<TranslationResponseModel> translateText(TranslationRequestModel request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.translate,
        body: request.toJson(),
      );
      return TranslationResponseModel.fromJson(response);
    } catch (e) {
      throw TranslationException('Failed to translate text: $e');
    }
  }
  
  @override
  Future<String> detectLanguage(String text) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.detectLanguage,
        body: {'text': text},
      );
      return response['language'] as String;
    } catch (e) {
      throw TranslationException('Failed to detect language: $e');
    }
  }
}


