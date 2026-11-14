import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;
  
  ApiClient({
    required this.client,
    required this.baseUrl,
  });
  
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters?.map((k, v) => MapEntry(k, v.toString())),
      );
      
      final response = await client
          .get(uri, headers: {...ApiConfig.defaultHeaders, ...?headers})
          .timeout(ApiConfig.connectionTimeout);
      
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw NetworkException('Unexpected error: $e');
    }
  }
  
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await client
          .post(
            uri,
            headers: {...ApiConfig.defaultHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);
      
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw NetworkException('Unexpected error: $e');
    }
  }
  
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode >= 500) {
      throw ServerException('Server error: ${response.statusCode}');
    } else {
      throw ServerException('Request failed: ${response.statusCode}');
    }
  }
}


