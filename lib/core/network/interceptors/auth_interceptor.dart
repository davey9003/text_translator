import '../../config/api_config.dart';

class AuthInterceptor {
  static Map<String, String> addAuthHeaders(Map<String, String> headers) {
    final apiKey = ApiConfig.apiKey;
    if (apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }
    return headers;
  }
}

