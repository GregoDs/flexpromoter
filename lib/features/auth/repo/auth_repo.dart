import 'package:dio/dio.dart';
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flexpromoter/utils/services/api_service.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();

  //Instance of the userModel
  UserModel? _userModel;

  // Function to request OTP
  Future<Response> requestOtp(String phoneNumber) async {
    try {
      // Build the endpoint URL
      final String url =
          "${dotenv.env["PROD_ENDPOINT_AUTH"]!}/promoter/send-otp";

      // Make the POST request
      final response = await _apiService.post(
        url,
        data: {
          "phone_number": phoneNumber,
        },
        requiresAuth: false, // No token required for requesting OTP
      );
      //update the usermodel here
      _userModel = UserModel(
        token: "",
        user: User(
          id: 0,
          email: "",
          userType: 0,
          isVerified: 0,
          phoneNumber: int.parse(phoneNumber), //Store the phoneNumber
        ),
      );

      // Log the response
      print("OTP request succeeded: ${response.data}");
      return response;
    } on DioException catch (e) {
      // Log the error
      print("OTP request failed: ${e.message}");
      rethrow; // Rethrow the error to handle it in the calling function
    }
  }



  // Function to verify OTP
  Future<Response> verifyOtp(String phoneNumber, String otp) async {
    try {
     
      final String url =
          "${dotenv.env["PROD_ENDPOINT_AUTH"]!}/promoter/verify-otp";

      final response = await _apiService.post(
        url,
        data: {
          "phone_number": phoneNumber,
          "otp": otp,
        },
        requiresAuth: false, 
      );

      // Parse the response data
      final responseData = response.data["data"];

      // Update the UserModel with the response data
      _userModel = UserModel(
        token: responseData["token"],
        user: User(
          id: responseData["user"]["id"],
          email: responseData["user"]["email"],
          userType: responseData["user"]["user_type"],
          isVerified: responseData["user"]["is_verified"],
          phoneNumber: responseData["user"]["phone_number"],
        ),
      );

      
      print("OTP verification succeeded: ${response.data}");
      return response;
    } on DioException catch (e) {
      
      print("OTP verification failed: ${e.message}");
      rethrow; 
    }
  }



  //Getter for the UserModel
  UserModel? get userModel => _userModel;
}
