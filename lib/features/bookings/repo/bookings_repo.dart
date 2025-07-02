import 'dart:developer' as developer;
import 'package:flexpromoter/exports.dart';
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flexpromoter/features/bookings/models/booking_response_model.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/features/bookings/models/make_bookings_model.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/utils/services/api_service.dart';
import 'package:flexpromoter/utils/services/error_handler.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart'
    as custom_snackbar;

class BookingsRepository {
  final ApiService _apiService = ApiService();

  // Fetch all types of bookings in parallel
  Future<Map<String, List<Booking>>> fetchAllBookings(int userId) async {
    try {
      //get user id from shared preferences
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        throw Exception('User Data not found. Please Login and try again');
      }
      //parse user data
      final userModel = UserModel.fromJson(userData);
      final userId = userModel.user.id.toString();

      developer.log('Fetching bookings for userId: $userId',
          name: 'BookingsRepository');

      final responses = await Future.wait([
        _apiService.get(
            '${ApiService.prodEndpointBookings}/promoter/bookings/open/$userId'),
        _apiService.get(
            '${ApiService.prodEndpointBookings}/promoter/bookings/closed/$userId'),
        _apiService.get(
            '${ApiService.prodEndpointBookings}/promoter/bookings/redeemed/$userId'),
        _apiService.get(
            '${ApiService.prodEndpointBookings}/promoter/bookings/unserviced/$userId'),
      ]);

      // Detailed logging for unserviced bookings response
      developer.log('=== UNSERVICED BOOKINGS RESPONSE START ===',
          name: 'BookingsRepository');
      developer.log('Status Code: ${responses[3].statusCode}',
          name: 'BookingsRepository');
      developer.log('Response Data: ${responses[3].data}',
          name: 'BookingsRepository');
      developer.log('=== UNSERVICED BOOKINGS RESPONSE END ===',
          name: 'BookingsRepository');

      // Process each response and use them directly
      final Map<String, List<Booking>> result = {
        'open': _parseBookingsResponse(responses[0]),
        'closed': _parseBookingsResponse(responses[1]),
        'redeemed': _parseBookingsResponse(responses[2]),
        'unserviced': _parseBookingsResponse(responses[3]),
      };

      // Log the counts for debugging
      developer.log(
          'Final result counts - Open: ${result['open']?.length}, '
          'Closed: ${result['closed']?.length}, '
          'Redeemed: ${result['redeemed']?.length}, '
          'Unserviced: ${result['unserviced']?.length}',
          name: 'BookingsRepository');

      // Additional logging for unserviced bookings after parsing
      if (result['unserviced']?.isNotEmpty ?? false) {
        developer.log('=== PARSED UNSERVICED BOOKINGS START ===',
            name: 'BookingsRepository');
        for (var booking in result['unserviced']!) {
          developer.log(
              'Booking ID: ${booking.id}, '
              'Reference: ${booking.bookingReference}, '
              'Status: ${booking.bookingStatus}, '
              'Customer: ${booking.customer.firstName} ${booking.customer.lastName}',
              name: 'BookingsRepository');
        }
        developer.log('=== PARSED UNSERVICED BOOKINGS END ===',
            name: 'BookingsRepository');
      } else {
        developer.log('No unserviced bookings found after parsing',
            name: 'BookingsRepository');
      }

      // Save fetched bookings to SharedPreferences
      // await SharedPreferencesHelper.saveBookings(
      //     result['open']!); // Save open bookings
      await SharedPreferencesHelper.saveClosedBookings(
          result['closed']!); // Save closed bookings
      // await SharedPreferencesHelper.saveBookings(
      //     result['redeemed']!); // Save redeemed bookings
      // await SharedPreferencesHelper.saveBookings(
      //     result['unserviced']!); // Save unserviced bookings

      return result;
    } catch (e) {
      developer.log('Error fetching bookings: $e',
          name: 'BookingsRepository', error: e);
      // Return empty lists for all types if there's an error
      return {
        'open': [],
        'closed': [],
        'redeemed': [],
        'unserviced': [],
      };
    }
  }

  // Helper method to parse booking responses
  List<Booking> _parseBookingsResponse(dynamic response) {
    try {
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> bookingsData = response.data['data'];
        final List<Booking> bookings = [];

        for (var json in bookingsData) {
          try {
            final booking = Booking.fromJson(json);
            bookings.add(booking);
          } catch (e, stackTrace) {
            developer.log(
                'Error parsing individual booking: $e\n'
                'Booking data: $json\n'
                'Stack trace: $stackTrace',
                name: 'BookingsRepository');
          }
        }

        developer.log('Successfully parsed ${bookings.length} bookings',
            name: 'BookingsRepository');
        return bookings;
      }
      return [];
    } catch (e, stackTrace) {
      developer.log(
          'Error parsing booking response: $e\n'
          'Response data: ${response.data}\n'
          'Stack trace: $stackTrace',
          name: 'BookingsRepository');
      return [];
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
      developer.log('Creating booking with payload: $payload',
          name: 'BookingsRepository');

      // Log the complete request URL
      final url = '${ApiService.prodEndpointBookings}/booking/promoter-create';
      developer.log('Request URL: $url', name: 'BookingsRepository');

      try {
        // Make the request with detailed logging
        final response = await _apiService.post(
          url,
          data: payload,
        );

        // Log the complete response
        developer.log('Response Status Code: ${response.statusCode}',
            name: 'BookingsRepository');
        developer.log('Response Data: ${response.data}',
            name: 'BookingsRepository');

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
        developer.log('DioException in createBooking: ${e.message}',
            name: 'BookingsRepository', error: e);

        // Handle timeout errors
        if (e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          await Future.delayed(const Duration(seconds: 2));

          try {
            final bookings = await fetchAllBookings(0);
            final recentBooking = bookings['open']?.firstWhere(
              (booking) =>
                  booking.customer.firstName == bookingRequest.firstName &&
                  booking.customer.lastName == bookingRequest.lastName &&
                  booking.customer.phoneNumber1 == bookingRequest.phoneNumber,
              orElse: () => throw Exception('Booking not found'),
            );

            if (recentBooking != null) {
              if (context.mounted) {
                custom_snackbar.CustomSnackBar.showSuccess(
                  context,
                  title: 'Success',
                  message:
                      'Booking was created successfully despite the timeout',
                );
              }
              return true;
            }
          } catch (verifyError) {
            developer.log('Error verifying booking: $verifyError',
                name: 'BookingsRepository');
          }
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
      developer.log('Error in createBooking: $e',
          name: 'BookingsRepository', error: e);
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

  // Prompt Booking Payment
  Future<PromptBookingPaymentResponse> promptBookingPayment(
      PromptBookingPaymentRequest request) async {
    try {
      // Log the request payload
      developer.log(
        'PromptBookingPayment REQUEST: ${request.toJson()}',
        name: 'BookingsRepository',
      );

      final response = await _apiService.post(
        '${ApiService.prodEndpointBookings}/booking/prompt-payment',
        data: request.toJson(),
      );

      // Log the full response data
      developer.log(
        'PromptBookingPayment RESPONSE: ${response.data}',
        name: 'BookingsRepository',
      );

      return PromptBookingPaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      developer.log(
        'PromptBookingPayment ERROR: ${e.response?.data ?? e.toString()}',
        name: 'BookingsRepository',
        error: e,
      );
      throw Exception(ErrorHandler.handleError(e));
    } catch (e) {
      developer.log(
        'PromptBookingPayment UNEXPECTED ERROR: $e',
        name: 'BookingsRepository',
        error: e,
      );
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Delete a booking

  // Helper method to handle errors and show snackbar
  void handleError(BuildContext context, dynamic error) {
    if (error is DioException) {
      final errorMessage = ErrorHandler.handleError(error);
      developer.log('API Error: $errorMessage',
          name: 'BookingsRepository', error: error);
      custom_snackbar.CustomSnackBar.showError(
        context,
        title: 'Error',
        message: errorMessage,
      );
    } else {
      developer.log('General Error: ${error.toString()}',
          name: 'BookingsRepository', error: error);
      custom_snackbar.CustomSnackBar.showError(
        context,
        title: 'Error',
        message: error.toString(),
      );
    }
  }
}
