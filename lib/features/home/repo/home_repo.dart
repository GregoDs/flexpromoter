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
      // Get the stored user data
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        throw Exception('User data not found. Please login again.');
      }

      // Parse user ID
      final userModel = UserModel.fromJson(userData);
      final localUserId = userModel.user.id.toString();

      developer.log('User ID loaded from SharedPreferences: $localUserId');

      // Retrieve the booking response from SharedPreferences
      final bookingResponse = await SharedPreferencesHelper.getBookingResponse();
      if (bookingResponse == null) {
        throw Exception('Booking response not found. Please make a booking.');
      }

      // Extract the booking reference and price from the booking response
      final bookingReference = bookingResponse.data?.productBooking?.bookingReference;
      final bookingPrice = bookingResponse.data?.productBooking?.bookingPrice.toString(); // Ensure it's a string

      if (bookingReference == null || bookingReference.isEmpty) {
        throw Exception('Booking reference is required.');
      }
      if (bookingPrice == null || bookingPrice.isEmpty) {
        throw Exception('Booking price is required.');
      }

      developer.log(
        'Booking data loaded - Reference: $bookingReference, Price: $bookingPrice',
      );

      developer.log('Sending validation request with data: {'
          '"user_id": $localUserId, '
          '"booking_reference": $bookingReference, '
          '"slip_no": $slipNo, '
          '"validated_amount": $bookingPrice'
          '}');

      // Send the validation request
      final response = await _apiService.post(
        '${ApiService.prodEndpointBookings}/promoters/validate-receipt',
        data: {
          'user_id': localUserId,
          'booking_reference': bookingReference,
          'slip_no': slipNo,
          'validated_amount': bookingPrice,
        },
      );

      developer.log('Validation Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to validate receipt');
      }
    } catch (e) {
      developer.log('Error during receipt validation: $e');
      rethrow;
    }
  }
}