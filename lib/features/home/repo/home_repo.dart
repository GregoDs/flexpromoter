import 'dart:developer' as developer;
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flexpromoter/utils/services/api_service.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'dart:core';

class HomeRepo {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> validateReceipt({
    required String slipNo,
  }) async {
    try {
      // Get stored user data
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null)
        throw Exception('User data not found. Please login again.');

      final userModel = UserModel.fromJson(userData);
      final localUserId = userModel.user.id.toString();

      developer.log('User ID loaded from SharedPreferences: $localUserId');

      // Get booking response
      final bookingResponse =
          await SharedPreferencesHelper.getBookingResponse();

      String? bookingReference =
          bookingResponse?.data?.productBooking?.bookingReference;
      String? bookingPrice =
          bookingResponse?.data?.productBooking?.bookingPrice?.toString();

      // If either value is missing, fallback to closed bookings
      if ((bookingReference == null || bookingReference.isEmpty) ||
          (bookingPrice == null || bookingPrice.isEmpty)) {
        developer.log('Fallback: Getting booking data from closed bookings...');

        // Get all closed bookings
        final closedBookings =
            await SharedPreferencesHelper.loadClosedBookings();

        if (closedBookings.isEmpty) {
          throw Exception('No closed booking data found.');
        }

        // Start the stopwatch to measure the time taken for the loop
        final stopwatch = Stopwatch()..start();

        Exception? lastError;
        
          // Loop through closed bookings and try each one
          for (final booking in closedBookings) {
            final ref = booking.bookingReference;
            final price = booking.bookingPrice?.toString();

            if (ref != null &&
                ref.isNotEmpty &&
                price != null &&
                price.isNotEmpty) {
              bookingReference = ref;
              bookingPrice = price;

              developer.log('Found booking - Reference: $bookingReference, Price: $bookingPrice');

              final requestData = {
                'user_id': localUserId,
                'booking_reference': bookingReference,
                'slip_no': slipNo,
                'validated_amount': bookingPrice,
              };

              developer.log('Sending validation request with data: $requestData');

              try {
                final response = await _apiService.post(
                  '${ApiService.prodEndpointBookings}/promoters/validate-receipt',
                  data: requestData,
                );

                developer.log('Validation Response: ${response.data}');

                if (response.statusCode == 200 || response.statusCode == 201) {
                  developer.log(
                    '🎉 Receipt Successfully Validated\n'
                    '➡ Reference: $bookingReference\n'
                    '➡ Price (validated_amount): $bookingPrice\n'
                    '➡ Slip No: $slipNo\n'
                    '➡ User ID: $localUserId',
                  );
                  return response.data;
                } else {
                  throw Exception(response.data['message']);
                }
              } catch (e) {
                lastError = Exception('❌ Validation failed for reference $ref: ${e.toString()}');
                developer.log(lastError.toString());
              }
            } else {
              developer.log('⚠️ Skipped invalid booking data - Reference: $ref, Price: ${price ?? "null"}');
            }
              // // Optionally wait between attempts, if needed:
              // await Future.delayed(const Duration(seconds: 5));
            }
        

        // Stop the stopwatch after the loop
        stopwatch.stop();
        developer.log('Time taken to loop through closed bookings: ${stopwatch.elapsedMilliseconds} ms');

        if (lastError != null) {
          throw lastError!;
        } else {
          throw Exception('All closed bookings were invalid.');
        }
      }

      developer.log(
          'Booking data used - Reference: $bookingReference, Price: $bookingPrice');

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
        developer.log(
          '🎉 Receipt Successfully Validated\n'
          '➡ Reference: $bookingReference\n'
          '➡ Price (validated_amount): $bookingPrice\n'
          '➡ Slip No: $slipNo\n'
          '➡ User ID: $localUserId',
        );
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