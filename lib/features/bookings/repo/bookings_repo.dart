import 'package:flexpromoter/exports.dart';
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flexpromoter/features/bookings/models/booking_response_model.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/features/bookings/models/make_bookings_model.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/utils/services/api_service.dart';
import 'package:flexpromoter/utils/services/error_handler.dart';
import 'package:flexpromoter/utils/services/logger.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart'
    as custom_snackbar;

class BookingsRepository {
  final ApiService _apiService = ApiService();

  // Fetch open bookings (Active)
  Future<Map<String, dynamic>> fetchOpenBookings({int page = 1}) async {
    final userData = await SharedPreferencesHelper.getUserData();
    if (userData == null) {
      throw Exception('User Data not found. Please Login and try again');
    }
    final userModel = UserModel.fromJson(userData);
    final userId = userModel.user.id.toString();
    // const userId = '141192';
    final response = await _apiService.get(
      '${ApiService.prodEndpointBookings}/promoter/bookings/open/$userId?page=$page',
    );
    return _parsePaginatedBookingsResponse(response.data);
  }

  // Fetch closed bookings (Completed)
  Future<Map<String, dynamic>> fetchClosedBookings({int page = 1}) async {
    final userData = await SharedPreferencesHelper.getUserData();
    if (userData == null) {
      throw Exception('User Data not found. Please Login and try again');
    }
    final userModel = UserModel.fromJson(userData);
    final userId = userModel.user.id.toString();
    // const userId = '141192';
    final response = await _apiService.get(
      '${ApiService.prodEndpointBookings}/promoter/bookings/closed/$userId ?page=$page',
    );
    return _parsePaginatedBookingsResponse(response.data);
  }

  // Fetch redeemed bookings
  Future<Map<String, dynamic>> fetchRedeemedBookings({int page = 1}) async {
    final userData = await SharedPreferencesHelper.getUserData();
    if (userData == null) {
      throw Exception('User Data not found. Please Login and try again');
    }
    final userModel = UserModel.fromJson(userData);
    final userId = userModel.user.id.toString();
    // const userId = '141192';
    final response = await _apiService.get(
      '${ApiService.prodEndpointBookings}/promoter/bookings/redeemed/$userId?page=$page',
    );
    return _parsePaginatedBookingsResponse(response.data);
  }

  // Fetch unserviced bookings
  Future<Map<String, dynamic>> fetchUnservicedBookings({int page = 1}) async {
    final userData = await SharedPreferencesHelper.getUserData();
    if (userData == null) {
      throw Exception('User Data not found. Please Login and try again');
    }
    final userModel = UserModel.fromJson(userData);
    final userId = userModel.user.id.toString();
    // const userId = '141192';
    final response = await _apiService.get(
      '${ApiService.prodEndpointBookings}/promoter/bookings/unserviced/$userId?page=$page',
    );
    return _parsePaginatedBookingsResponse(response.data);
  }

  // Helper method to parse booking responses
  List<Booking> _parseBookingsResponse(dynamic response) {
    try {
      // Case 1: If response is like {data: {data: [...]}}
      if (response is Map<String, dynamic> &&
          response['data'] is Map<String, dynamic> &&
          response['data']['data'] is List) {
        return (response['data']['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((json) => Booking.fromJson(json))
            .toList();
      }

      //Case 2; if response is {data:[]}
      if (response is Map<String, dynamic> && response['data'] is List) {
        return (response['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((json) => Booking.fromJson(json))
            .toList();
      }

      // If response is directly a List of bookings
      if (response is List) {
        return response
            .whereType<Map<String, dynamic>>()
            .map((json) => Booking.fromJson(json))
            .toList();
      }
      // Log unexpected format
      print('Unexpected bookings response format: $response');
      return [];
    } catch (e) {
      print('Error parsing bookings response: $e');
      return [];
    }
  }

  Map<String, dynamic> _parsePaginatedBookingsResponse(dynamic response) {
    try {
      if (response is Map<String, dynamic> &&
          response['data'] is Map<String, dynamic> &&
          response['data']['data'] is List) {
        final bookings = (response['data']['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((json) => Booking.fromJson(json))
            .toList();
        final totalPages = response['data']['last_page'] ?? 1;
        return {
          'bookings': bookings,
          'totalPages': totalPages,
        };
      }
      print('Unexpected bookings response format: $response');
      return {'bookings': [], 'totalPages': 1};
    } catch (e) {
      print('Error parsing bookings response: $e');
      return {'bookings': [], 'totalPages': 1};
    }
  }

  // Create a new booking
  Future<bool> createBooking(
      BuildContext context, BookingRequestModel bookingRequest) async {
    try {
      // Get user data from SharedPreferences
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        throw Exception('User Data not found. Please Login and try again');
      }

      // Parse user data and get userId
      final userModel = UserModel.fromJson(userData);
      final userId = userModel.user.id.toString();

      // Create a new booking request with the userId from SharedPreferences
      final updatedBookingRequest = BookingRequestModel(
        phoneNumber: bookingRequest.phoneNumber,
        userId: userId,
        bookingPrice: bookingRequest.bookingPrice,
        bookingDays: bookingRequest.bookingDays,
        initialDeposit: bookingRequest.initialDeposit,
        firstName: bookingRequest.firstName,
        lastName: bookingRequest.lastName,
        productName: bookingRequest.productName,
      );

      // Log the request payload
      final payload = updatedBookingRequest.toJson();
      AppLogger.log(
        'Creating booking with payload: $payload',
      );

      // Log the complete request URL
      final url = '${ApiService.prodEndpointBookings}/booking/promoter-create';
      AppLogger.log(
        'Request URL: $url',
      );

      try {
        // Make the request with detailed logging
        final response = await _apiService.post(
          url,
          data: payload,
        );

        // Log the complete response
        AppLogger.log(
          'Response Status Code: ${response.statusCode}',
        );
        AppLogger.log(
          'Response Data: ${response.data}',
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final bookingResponse = BookingResponseModel.fromJson(response.data);

          // Save booking response to SharedPreferences
          await SharedPreferencesHelper.saveBookingResponse(bookingResponse);

          // Save booking reference and price to SharedPreferences
          final bookingReference = response.data['bookingReference'] ?? '';
          final bookingPrice = response.data['bookingPrice'] ?? '0';

          await SharedPreferencesHelper.saveBookingData(
            bookingReference: bookingReference,
            bookingPrice: bookingPrice,
          );

          // Show success message
          if (context.mounted) {
            custom_snackbar.CustomSnackBar.showSuccess(
              context,
              title: 'Success',
              message:
                  response.data['message'] ?? 'Booking created successfully',
            );
          }
          return true;
        }
      } on DioException catch (e) {
        AppLogger.log(
          'DioException in createBooking: ${e.message}',
        );

        // Handle timeout errors
        if (e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          await Future.delayed(const Duration(seconds: 2));

          // try {
          //   // final bookings = await fetchAllBookings(0);
          //   final recentBooking = bookings['open']?.firstWhere(
          //     (booking) =>
          //         booking.customer?.firstName == bookingRequest.firstName &&
          //         booking.customer?.lastName == bookingRequest.lastName &&
          //         booking.customer?.phoneNumber1 == bookingRequest.phoneNumber,
          //     orElse: () => throw Exception('Booking not found'),
          //   );

          //     if (recentBooking != null) {
          //       if (context.mounted) {
          //         custom_snackbar.CustomSnackBar.showSuccess(
          //           context,
          //           title: 'Success',
          //           message:
          //               'Booking was created successfully despite the timeout',
          //         );
          //       }
          //       return true;
          //     }
          //   } catch (verifyError) {
          //     AppLogger.log('Error verifying booking: $verifyError',
          //         ');
          //   }
        }

        if (context.mounted) {
          String errorMessage =
              'An error occurred while creating the booking. ';
          if (e.type == DioExceptionType.receiveTimeout) {
            errorMessage +=
                'The server is taking longer than usual to respond. Please check your bookings to verify if it was created.';
          } else {
            errorMessage += ErrorHandler.handleError(e);
          }
          custom_snackbar.CustomSnackBar.showError(
            context,
            title: 'Warning',
            message: errorMessage,
          );
        }
        return false;
      }

      throw Exception('Failed to create booking');
    } catch (e) {
      AppLogger.log(
        'Error in createBooking: $e',
      );
      if (context.mounted) {
        custom_snackbar.CustomSnackBar.showError(
          context,
          title: 'Error',
          message: e.toString(),
        );
      }
      return false;
    }
  }

//Search for customer bookings
  Future<Map<String, dynamic>> searchCustomerBookings({
    required String phoneNumber,
    required String bookingType,
    int page = 1,
  }) async {
    final userData = await SharedPreferencesHelper.getUserData();
    if (userData == null) {
      throw Exception('User Data not found. Please Login and try again');
    }
    final userModel = UserModel.fromJson(userData);
    final userId = userModel.user.id.toString();

    final response = await _apiService.get(
      '${ApiService.prodEndpointBookings}/promoter/bookings/$bookingType/$userId',
      queryParameters: {'phone_number': phoneNumber, 'page': page},
    );
    // Use paginated parser
    return _parsePaginatedBookingsResponse(response.data);
  }

  // Prompt Booking Payment
  Future<PromptBookingPaymentResponse> promptBookingPayment(
      PromptBookingPaymentRequest request) async {
    try {
      // Log the request payload
      AppLogger.log(
        'PromptBookingPayment REQUEST: ${request.toJson()}',
      );

      final response = await _apiService.post(
        '${ApiService.prodEndpointBookings}/booking/prompt-payment',
        data: request.toJson(),
      );

      // Log the full response data
      AppLogger.log(
        'PromptBookingPayment RESPONSE: ${response.data}',
      );

      return PromptBookingPaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.log(
        'PromptBookingPayment ERROR: ${e.response?.data ?? e.toString()}',
      );
      throw Exception(ErrorHandler.handleError(e));
    } catch (e) {
      AppLogger.log(
        'PromptBookingPayment UNEXPECTED ERROR: $e',
      );
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Delete a booking

  // Helper method to handle errors and show snackbar
  void handleError(BuildContext context, dynamic error) {
    if (error is DioException) {
      final errorMessage = ErrorHandler.handleError(error);
      AppLogger.log(
        'API Error: $errorMessage',
      );
      custom_snackbar.CustomSnackBar.showError(
        context,
        title: 'Error',
        message: errorMessage,
      );
    } else {
      AppLogger.log(
        'General Error: ${error.toString()}',
      );
      custom_snackbar.CustomSnackBar.showError(
        context,
        title: 'Error',
        message: error.toString(),
      );
    }
  }
}
