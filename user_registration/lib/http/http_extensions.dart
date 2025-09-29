import 'package:http/http.dart' as http;

extension HttpResponseExtensions on http.Response {
  String get statusMessage {
    return _statusMessages[statusCode] ?? 'Unknown Status';
  }

  static final _statusMessages = {
    200: 'OK',
    201: 'Created',
    400: 'Bad Request',
    401: 'Unauthorized',
    403: 'Forbidden',
    404: 'Not Found',
    500: 'Internal Server Error',
  };
}
