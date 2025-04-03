import 'package:flexpromoter/exports.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/utils/services/error_handler.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(milliseconds: 5000), // 5 seconds
      receiveTimeout: const Duration(milliseconds: 5000), // 5 seconds
    ),
  );

  // Base URLs
  static String prodEndpointAuth = dotenv.env["PROD_ENDPOINT_AUTH"]!;
  static String prodEndpointBookings = dotenv.env['PROD_ENDPOINT_BOOKINGS']!;

  // Generic GET request
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters, bool requiresAuth = true}) async {
    try {
      final headers = await _buildHeaders(requiresAuth);
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      print("GET Request to $url succeeded with response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("GET Request to $url failed with error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String url,
      {Map<String, dynamic>? data, bool requiresAuth = true}) async {
    try {
      final headers = await _buildHeaders(requiresAuth);
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print("POST Request to $url succeeded with response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("POST Request to $url failed with error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(String url,
      {Map<String, dynamic>? data, bool requiresAuth = true}) async {
    try {
      final headers = await _buildHeaders(requiresAuth);
      final response = await _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print("PUT Request to $url succeeded with response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("PUT Request to $url failed with error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(String url,
      {Map<String, dynamic>? data, bool requiresAuth = true}) async {
    try {
      final headers = await _buildHeaders(requiresAuth);
      final response = await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print("DELETE Request to $url succeeded with response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("DELETE Request to $url failed with error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // Build headers with optional token
  Future<Map<String, String>> _buildHeaders(bool requiresAuth) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await SharedPreferencesHelper.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Exception _handleDioError(DioException error) {
    final errorMessage = ErrorHandler.handleError(error);
    return Exception(errorMessage);
  }
}