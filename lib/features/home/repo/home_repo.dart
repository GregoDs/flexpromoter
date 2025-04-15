import 'dart:developer' as developer;
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flexpromoter/features/bookings/models/booking_response_model.dart';
import 'package:flexpromoter/utils/services/api_service.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';

class HomeRepo {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> validateReceipt({
    required String slipNo,
  }) async {
    try {
      // Get stored user data
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) throw Exception('User data not found. Please login again.');

      final userModel = UserModel.fromJson(userData);
      final localUserId = userModel.user.id.toString();

      developer.log('User ID loaded from SharedPreferences: $localUserId');

      // Get booking response
      final bookingResponse = await SharedPreferencesHelper.getBookingResponse();

      String? bookingReference = bookingResponse?.data?.productBooking?.bookingReference;
      String? bookingPrice = bookingResponse?.data?.productBooking?.bookingPrice?.toString();

      // If either value is missing, fallback to closed bookings
      if ((bookingReference == null || bookingReference.isEmpty) ||
          (bookingPrice == null || bookingPrice.isEmpty)) {
        developer.log('Fallback: Getting booking data from closed bookings...');

        final closedBookings = await SharedPreferencesHelper.loadClosedBookings();

        if (closedBookings.isEmpty) {
          throw Exception('No closed booking data found.');
        }

        final firstBooking = closedBookings[0];

        bookingReference = firstBooking.bookingReference;
        bookingPrice = firstBooking.bookingPrice?.toString();

        if (bookingReference == null || bookingReference.isEmpty) {
          throw Exception('Booking reference is required.');
        }

        if (bookingPrice == null || bookingPrice.isEmpty) {
          throw Exception('Booking price is required.');
        }
      }

      developer.log('Booking data used - Reference: $bookingReference, Price: $bookingPrice');

      final requestData = {
        'user_id': localUserId,
        'booking_reference': bookingReference,
        'slip_no': slipNo,
        'validated_amount': bookingPrice,
      };

      developer.log('Sending validation request with data: $requestData');

      final response = await _apiService.post(
        '${ApiService.prodEndpointBookings}/promoters/validate-receipt',
        data: requestData,
      );

      developer.log('Validation Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      developer.log('Error during receipt validation: $e');
      rethrow;
    }
  }
}