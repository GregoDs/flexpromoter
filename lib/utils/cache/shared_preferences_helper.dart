import 'dart:convert';
import 'package:flexpromoter/utils/services/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/features/bookings/models/booking_response_model.dart';

// Pretty Print Helper
String prettyPrintJson(dynamic jsonObj) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(jsonObj);
}

class SharedPreferencesHelper {
  static const String _tokenKey = 'token';
  static const String _userDataKey = 'user_data';
  static const String _bookingResponseKey = 'booking_response';
  static const String _bookingReferenceKey = 'booking_reference';
  static const String _validatedAmountKey = 'validated_amount';

  // ================= TOKEN HANDLING =================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool('isLoggedIn', true);

    AppLogger.log("🔑 Token saved (hidden in production)");
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.setBool('isLoggedIn', false);

    AppLogger.log("🗑️ Token cleared");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_bookingReferenceKey);
    await prefs.remove(_validatedAmountKey);
    await prefs.remove(_bookingResponseKey);
    await prefs.setBool('isLoggedIn', false);

    AppLogger.log("🚪 User successfully logged out");
  }

  // ================= USER DATA HANDLING =================
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));

    AppLogger.log("👤 User data saved:\n${prettyPrintJson(userData)}");
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString == null) return null;

    try {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.log("❌ Failed to decode user data: $e");
      return null;
    }
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);

    AppLogger.log("🗑️ User data cleared");
  }

  // ================= CLOSED BOOKINGS =================
  static Future<void> saveClosedBookings(List<Booking> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJsonList = bookings.map((b) => b.toJson()).toList();
    final bookingsString = jsonEncode(bookingsJsonList);
    await prefs.setString('closed_bookings', bookingsString);

    AppLogger.log("📦 Saved closed bookings:\n${prettyPrintJson(bookingsJsonList)}");
  }

  static Future<List<Booking>> loadClosedBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsString = prefs.getString('closed_bookings');

    if (bookingsString == null) {
      AppLogger.log("ℹ️ No closed bookings found in storage");
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(bookingsString);
      AppLogger.log("📥 Loaded closed bookings:\n${prettyPrintJson(decodedList)}");

      return decodedList.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      AppLogger.log("❌ Error loading closed bookings: $e");
      return [];
    }
  }

  // ================= BOOKING DATA =================
  static Future<void> saveBookingData({
    required String bookingReference,
    required String bookingPrice,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bookingReferenceKey, bookingReference);
    await prefs.setString(_validatedAmountKey, bookingPrice);

    AppLogger.log("💾 Booking data saved - Reference: $bookingReference, Price: $bookingPrice");
  }

  static Future<String?> getBookingReference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_bookingReferenceKey);
  }

  static Future<String?> getBookingPrice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_validatedAmountKey);
  }

  static Future<void> saveBookingResponse(BookingResponseModel response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bookingResponseKey, jsonEncode(response.toJson()));

    AppLogger.log("📄 Full booking response saved");
  }

  static Future<BookingResponseModel?> getBookingResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_bookingResponseKey);

    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        return BookingResponseModel.fromJson(jsonMap);
      } catch (e) {
        AppLogger.log("❌ Failed to decode booking response: $e");
      }
    }
    return null;
  }

  static Future<void> clearBookingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookingReferenceKey);
    await prefs.remove(_validatedAmountKey);
    await prefs.remove(_bookingResponseKey);

    AppLogger.log("🗑️ Booking data cleared");
  }
}