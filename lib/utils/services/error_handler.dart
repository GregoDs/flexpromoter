import 'package:dio/dio.dart';

class ErrorHandler {
  static String handleError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    // ✅ Parse error from response data
    if (data is Map<String, dynamic>) {
      // ✅ Check nested: data.data.errors
      final nestedErrors =
          data['data'] is Map<String, dynamic> ? data['data']['errors'] : null;

      if (nestedErrors != null) {
        if (nestedErrors is List && nestedErrors.isNotEmpty) {
          return nestedErrors.join(', ');
        } else if (nestedErrors is String && nestedErrors.isNotEmpty) {
          return nestedErrors;
        }
      }

      // ✅ Check top-level: data.errors
      final topLevelErrors = data['errors'];
      if (topLevelErrors != null) {
        if (topLevelErrors is List && topLevelErrors.isNotEmpty) {
          return topLevelErrors.join(', ');
        } else if (topLevelErrors is String && topLevelErrors.isNotEmpty) {
          return topLevelErrors;
        }
      }

      // ✅ Check top-level: data.message
      if (data['message'] is String && (data['message'] as String).isNotEmpty) {
        return data['message'];
      }

      // ✅ Check top-level: data.data as error string/list
      final rawData = data['data'];
      if (rawData is List && rawData.isNotEmpty) {
        return rawData.map((e) => e.toString()).join(', ');
      } else if (rawData is String && rawData.isNotEmpty) {
        return rawData;
      }
    }

    // ✅ Fallback based on status code
    switch (statusCode) {
      case 400:
        return "Bad request. Please check your input.";
      case 401:
        return "Unauthorized. Please log in again.";
      case 403:
        return "Forbidden. You don't have permission to access this resource.";
      case 404:
        return "Resource not found. Please try again.";
      case 422:
        return "Validation error. Please check your input.";
      case 500:
        return "Internal server error. Please try again later.";
      case 503:
        return "Service unavailable. Please try again later.";
      default:
        if (statusCode != null) {
          return "Unexpected error: $statusCode. Please try again.";
        }
    }

    // ✅ Handle Dio-specific errors
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet connection.";
      case DioExceptionType.sendTimeout:
        return "Send timeout. Please check your internet connection.";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout. Please check your internet connection.";
      case DioExceptionType.cancel:
        return "Request was cancelled. Please try again.";
      case DioExceptionType.badCertificate:
        return "Bad certificate. Please check your network security.";
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return "Something went wrong. Please check your internet connection.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }
}
