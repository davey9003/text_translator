import 'package:http/http.dart' as http;
import '../../utils/helpers/logger.dart';

class LoggingInterceptor {
  static void logRequest(http.Request request) {
    Logger.debug('Request: ${request.method} ${request.url}');
    Logger.debug('Headers: ${request.headers}');
    if (request.body.isNotEmpty) {
      Logger.debug('Body: ${request.body}');
    }
  }
  
  static void logResponse(http.Response response) {
    Logger.debug('Response: ${response.statusCode} ${response.reasonPhrase}');
    Logger.debug('Body: ${response.body}');
  }
}


