import 'package:dio/dio.dart';
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flexpromoter/utils/services/api_service.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();

  UserModel? _userModel;

  // Function to request OTP
  Future<Response> requestOtp(String phoneNumber) async {
    try {
      final endpoint = dotenv.env["PROD_ENDPOINT_AUTH"];
      if (endpoint == null) {
        throw Exception("PROD_ENDPOINT_AUTH is not set in .env");
      }

      final String url = "$endpoint/promoter/send-otp";

      final response = await _apiService.post(
        url,
        data: {
          "phone_number": phoneNumber,
        },
        requiresAuth: false,
      );

      _userModel = UserModel(
        token: "",
        user: User(
          id: 0,
          email: "",
          userType: 0,
          isVerified: 0,
          phoneNumber: int.tryParse(phoneNumber) ?? 0,
        ),
      );

      print("OTP request succeeded: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("OTP request failed: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unexpected error during OTP request: $e");
      rethrow;
    }
  }

  // Function to verify OTP
  Future<Response> verifyOtp(String phoneNumber, String otp) async {
    try {
      final endpoint = dotenv.env["PROD_ENDPOINT_AUTH"];
      if (endpoint == null) {
        throw Exception("PROD_ENDPOINT_AUTH is not set in .env");
      }

      final String url = "$endpoint/promoter/verify-otp";

      final response = await _apiService.post(
        url,
        data: {
          "phone_number": phoneNumber,
          "otp": otp,
        },
        requiresAuth: false,
      );

      final responseData = response.data["data"];
      if (responseData == null || responseData["user"] == null) {
        throw Exception("Invalid response data");
      }

      _userModel = UserModel(
        token: responseData["token"] ?? "",
        user: User(
          id: responseData["user"]["id"] ?? 0,
          email: responseData["user"]["email"] ?? "",
          userType: responseData["user"]["user_type"] ?? 0,
          isVerified: responseData["user"]["is_verified"] ?? 0,
          phoneNumber: responseData["user"]["phone_number"] ?? 0,
        ),
      );

      await SharedPreferencesHelper.saveUserData(response.data);
      await SharedPreferencesHelper.saveToken(responseData["token"] ?? "");

      print("OTP verification succeeded: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("OTP verification failed: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unexpected error during OTP verification: $e");
      rethrow;
    }
  }

  UserModel? get userModel => _userModel;
}

// Logout function
Future<void> logout() async {
  await SharedPreferencesHelper.clearToken();
  await SharedPreferencesHelper.clearUserData();
}