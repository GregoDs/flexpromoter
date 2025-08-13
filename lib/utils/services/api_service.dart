import 'package:flexpromoter/exports.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/utils/services/error_handler.dart';
import 'package:flexpromoter/utils/services/logger.dart';

class ApiService {
  static String prodEndpointAuth = dotenv.env["PROD_ENDPOINT_AUTH"]!;
  static String prodEndpointBookings = dotenv.env['PROD_ENDPOINT_BOOKINGS']!;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Auth header
          if (options.extra['requiresAuth'] == true) {
            final token = await SharedPreferencesHelper.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          // Debug logging
          AppLogger.apiRequest(
            method: options.method,
            uri: options.uri,
            headers: options.headers,
            query: options.queryParameters,
            body: options.data,
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.apiResponse(
            statusCode: response.statusCode,
            method: response.requestOptions.method,
            uri: response.requestOptions.uri,
            data: response.data,
          );
          // Forward the response so awaiting callers can continue
          handler.next(response);
        },
        onError: (DioException error, handler) {
          AppLogger.apiError(
            type: error.type.toString(),
            method: error.requestOptions.method,
            uri: error.requestOptions.uri,
            statusCode: error.response?.statusCode,
            data: error.response?.data,
          );

          final message = ErrorHandler.handleError(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: message,
            ),
          );
        },
      ),
    );
  }

  // Requests
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters, bool requiresAuth = true}) {
    return _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(extra: {'requiresAuth': requiresAuth}),
    );
  }

  Future<Response> post(String url, {dynamic data, bool requiresAuth = true}) {
    return _dio.post(
      url,
      data: data,
      options: Options(extra: {'requiresAuth': requiresAuth}),
    );
  }

  Future<Response> put(String url,
      {Map<String, dynamic>? data, bool requiresAuth = true}) {
    return _dio.put(
      url,
      data: data,
      options: Options(extra: {'requiresAuth': requiresAuth}),
    );
  }

  Future<Response> delete(String url,
      {Map<String, dynamic>? data, bool requiresAuth = true}) {
    return _dio.delete(
      url,
      data: data,
      options: Options(extra: {'requiresAuth': requiresAuth}),
    );
  }

  // // Helpers
  // String _redactHeaders(Map<String, dynamic> headers) {
  //   final copy = Map<String, dynamic>.from(headers);
  //   if (copy.containsKey('Authorization')) {
  //     copy['Authorization'] = 'Bearer ***';
  //   }
  //   return copy.toString();
  // }

  // String _shorten(dynamic data, {int max = 1000}) {
  //   try {
  //     final s = data is String ? data : data.toString();
  //     return s.length > max ? '${s.substring(0, max)}...' : s;
  //   } catch (_) {
  //     return '<unprintable payload>';
  //   }
  // }
}
