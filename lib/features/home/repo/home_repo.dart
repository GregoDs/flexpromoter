import 'dart:developer' as developer;
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flexpromoter/utils/services/api_service.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:dio/dio.dart';
import 'dart:core';

import 'package:flexpromoter/utils/services/logger.dart';

class HomeRepo {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> validateReceipt({required String slipNo}) async {
    try {
      // Fetch user data
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        throw Exception('User data not found. Please login again.');
      }

      final userModel = UserModel.fromJson(userData);
      final localUserId = userModel.user.id.toString();
      AppLogger.log('User ID loaded from SharedPreferences: $localUserId');

      // Fetch booking details
      AppLogger.log('Fetching booking details for receipt: $slipNo');
      final bookingResponse = await _apiService.post(
        '${ApiService.prodEndpointBookings}/booking/by-receipt',
        data: {
          'user_id': localUserId,
          'receipt_no': slipNo,
        },
      );

      if (bookingResponse.statusCode != 200 || bookingResponse.data == null) {
        throw Exception(
            'Failed to fetch booking details (Status: ${bookingResponse.statusCode})');
      }

      // Parse booking data
      final productBooking = bookingResponse.data['data'];
      if (productBooking == null) {
        // Let the validation endpoint handle the invalid slip
        AppLogger.log('No booking found — skipping validation step.');
        return {
          "data": {
            "errors": ["No booking found for receipt $slipNo"],
          }
        };
      }

      final bookingReference = productBooking['booking_reference']?.toString();
      final bookingPrice = productBooking['booking_price'].toString();
      final bookingUserId = productBooking['user_id']?.toString();

      // Validate required fields
      if (bookingReference == null || bookingReference.isEmpty) {
        throw Exception('Invalid booking reference');
      }
      if (bookingPrice == null) {
        throw Exception('Invalid booking price');
      }
      if (bookingUserId == null || bookingUserId.isEmpty) {
        throw Exception('Invalid user ID in booking');
      }

      AppLogger.log(
          'Booking data: Reference=$bookingReference, Price=$bookingPrice, UserID=$bookingUserId');

      // Validate receipt
      final validationData = {
        "user_id": localUserId,
        "booking_reference": bookingReference,
        "slip_no": slipNo,
        "validated_amount": bookingPrice
      };

      AppLogger.log('Sending validation request: $validationData');

      final validationResponse = await _apiService.post(
        '${ApiService.prodEndpointBookings}/promoters/validate-receipt',
        data: validationData,
      );
      final responseData = validationResponse.data;
      AppLogger.log('Validation response: $responseData');

      // 1) If top-level success is explicitly false -> try to surface nested errors
      if (responseData['success'] == false) {
        final nestedErrors = responseData['data']?['errors'];
        if (nestedErrors is List && nestedErrors.isNotEmpty) {
          throw DioException(
            requestOptions: validationResponse.requestOptions,
            response: Response(
              requestOptions: validationResponse.requestOptions,
              statusCode: 422,
              data: {
                "data": {"errors": nestedErrors}
              },
            ),
            type: DioErrorType.badResponse,
          );
        } else if (nestedErrors is String && nestedErrors.isNotEmpty) {
          throw DioException(
            requestOptions: validationResponse.requestOptions,
            response: Response(
              requestOptions: validationResponse.requestOptions,
              statusCode: 422,
              data: {
                "data": {
                  "errors": [nestedErrors]
                }
              },
            ),
            type: DioErrorType.badResponse,
          );
        }
      }

      // 2) If top-level success is true BUT nested payload indicates failure
      final nestedData = responseData['data'];
      if (nestedData is Map<String, dynamic>) {
        final nestedSuccess = nestedData['success'];
        final nestedErrors = nestedData['errors'];

        final hasNonEmptyListErrors =
            nestedErrors is List && nestedErrors.isNotEmpty;
        final hasNonEmptyStringError =
            nestedErrors is String && nestedErrors.isNotEmpty;

        if (nestedSuccess == false ||
            hasNonEmptyListErrors ||
            hasNonEmptyStringError) {
          final normalizedErrors = hasNonEmptyListErrors
              ? nestedErrors
              : hasNonEmptyStringError
                  ? [nestedErrors]
                  : ["Validation failed"]; // fallback

          throw DioException(
            requestOptions: validationResponse.requestOptions,
            response: Response(
              requestOptions: validationResponse.requestOptions,
              statusCode: 422,
              data: {
                "data": {"errors": normalizedErrors}
              },
            ),
            type: DioErrorType.badResponse,
          );
        }
      }

      // 3) Legacy guard: throw only if top-level success not true AND nested errors non-empty
      if (responseData['success'] != true) {
        final nestedErrors = responseData['data']?['errors'];
        if (nestedErrors != null) {
          if (nestedErrors is List && nestedErrors.isNotEmpty) {
            throw DioException(
              requestOptions: validationResponse.requestOptions,
              response: Response(
                requestOptions: validationResponse.requestOptions,
                statusCode: 422,
                data: {
                  "data": {"errors": nestedErrors}
                },
              ),
              type: DioErrorType.badResponse,
            );
          } else if (nestedErrors is String && nestedErrors.isNotEmpty) {
            throw DioException(
              requestOptions: validationResponse.requestOptions,
              response: Response(
                requestOptions: validationResponse.requestOptions,
                statusCode: 422,
                data: {
                  "data": {
                    "errors": [nestedErrors]
                  }
                },
              ),
              type: DioErrorType.badResponse,
            );
          }
        }
      }

      // If we reach here, treat as success
      return responseData;
    } catch (e) {
      AppLogger.log('❌ Receipt validation error: $e');
      rethrow;
    }

    //   if (validationResponse.statusCode == 200 ||
    //       validationResponse.statusCode == 201) {
    //     AppLogger.log('✅ Receipt validated successfully');
    //     return validationResponse.data;
    //   } else {
    //     // Extract backend error details
    //     final errorDetails = validationResponse.data['data'] ?? {};
    //     final errorMessage = errorDetails.entries
    //         .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
    //         .join('; ');

    //     final errorMsg = errorMessage.isNotEmpty
    //         ? errorMessage
    //         : 'Validation failed (Status: ${validationResponse.statusCode})';

    //     AppLogger.log('❌ Receipt validation error: $errorMsg');
    //     throw Exception(errorMsg);
    //   }
    // } catch (e) {
    //   AppLogger.log('❌ Receipt validation error: $e');
    //   rethrow; // Pass the error up to the caller
    // }
  }

//Delete Account Function
  Future<Response> deleteAccount() async {
    // Fetch user data
    final userData = await SharedPreferencesHelper.getUserData();
    if (userData == null) {
      throw Exception('User data not found. Please login again.');
    }
    final userModel = UserModel.fromJson(userData);
    final localUserId = userModel.user.id.toString();

    const String url =
        "https://www.flexpay.co.ke/users/api/delete-customer-data";

    final response = await _apiService.post(
      url,
      data: {
        'user_id': localUserId,
      },
      requiresAuth: true,
    );

    return response;
  }
}
