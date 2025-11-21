import 'dart:convert';
import 'dart:developer' as AppLogger;

import 'package:dio/dio.dart';
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flexpromoter/features/wallet/model/register_model/customer_reg_model.dart';
import 'package:flexpromoter/features/wallet/model/wallet_otp_model/wallet_otp_model.dart';
import 'package:flexpromoter/features/wallet/model/create_wallet_model/create_wallet_model.dart';
import 'package:flexpromoter/features/wallet/model/promoter_referrals_model/promoter_referrals_model.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/utils/services/api_service.dart';
import 'package:flexpromoter/utils/services/error_handler.dart';

// Add the missing ApiService instance
final ApiService _apiService = ApiService();

Future<CustomerWalletRegResponse> registerCustomerWallet({
  required String phoneNumber,
}) async {
  try {
    AppLogger.log("📤 Registering customer...");

    final url = "${ApiService.prodEndpointWallet}/register-user-with-phone";

    final payload = {
      "phone_number": phoneNumber,
      "send_otp": true,
    };

    AppLogger.log("📦 Voucher Payload: $payload");

    final response = await _apiService.post(
      url,
      requiresAuth: true,
      data: payload,
    );

    // ✔ Correct model parsing
    final walletRegResponse = CustomerWalletRegResponse.fromJson(response.data);

    // ✔ Check backend error field
    if (walletRegResponse.errors != null &&
        walletRegResponse.errors!.isNotEmpty) {
      AppLogger.log("⚠️ Backend errors: ${walletRegResponse.errors}");
      throw Exception(walletRegResponse.errors!.first.toString());
    }

    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(walletRegResponse.toJson());
    AppLogger.log("✅ Wallet registration Response:\n$prettyJson");

    return walletRegResponse;
  } catch (e, stack) {
    // Fix the error handler to handle different exception types
    String message;
    if (e is DioException) {
      message = ErrorHandler.handleError(e);
    } else {
      message = e.toString();
    }
    AppLogger.log("❌ Error in wallet registration: $message\n$stack");
    throw (message);
  }
}

//VERIFY THE CUSTOMER

Future<WalletOtpResponse> verifyCustomerOtp({
  required String phoneNumber,
  required String otp,
}) async {
  try {
    AppLogger.log("📤 Verifying customer OTP...");

    final url = "${ApiService.prodEndpointWallet}/app/verify-otp";

    final payload = {
      "phone_number": phoneNumber,
      "otp": otp,
    };

    AppLogger.log("📦 OTP Verification Payload: $payload");

    final response = await _apiService.post(
      url,
      requiresAuth: true,
      data: payload,
    );

    // Parse the response using the correct OTP model
    final otpVerifyResponse = WalletOtpResponse.fromJson(response.data);

    // Check backend error field
    if (otpVerifyResponse.errors != null &&
        otpVerifyResponse.errors!.isNotEmpty) {
      AppLogger.log("⚠️ Backend errors: ${otpVerifyResponse.errors}");
      throw Exception(otpVerifyResponse.errors!.first.toString());
    }

    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(otpVerifyResponse.toJson());
    AppLogger.log("✅ OTP verification Response:\n$prettyJson");

    return otpVerifyResponse;
  } catch (e, stack) {
    // Handle different exception types
    String message;
    if (e is DioException) {
      message = ErrorHandler.handleError(e);
    } else {
      message = e.toString();
    }
    AppLogger.log("❌ Error in OTP verification: $message\n$stack");
    throw (message);
  }
}

//CREATE WALLET AFTER SUCCESSFUL OTP VERIFICATION
Future<CreateWalletResponse> createCustomerWallet({
  required String merchantId,
  required int customerId,
  required int promoterId,
  String bookingSource = "app",
}) async {
  try {
    AppLogger.log("📤 Creating customer wallet...");

    final url =
        "${ApiService.prodEndpointCreateWallet}/create-merchant-booking";

    final payload = {
      "merchant_id": merchantId,
      "user_id": customerId,
      "promoter_id": promoterId,
      "booking_source": bookingSource,
    };

    AppLogger.log("📦 Create Wallet Payload: $payload");

    final response = await _apiService.post(
      url,
      requiresAuth: true,
      data: payload,
    );

    // Parse the response using the CreateWalletResponse model
    final createWalletResponse = CreateWalletResponse.fromJson(response.data);

    // Check backend error field
    if (createWalletResponse.errors != null &&
        createWalletResponse.errors!.isNotEmpty) {
      AppLogger.log("⚠️ Backend errors: ${createWalletResponse.errors}");
      throw Exception(createWalletResponse.errors!.first.toString());
    }

    final prettyJson = const JsonEncoder.withIndent('  ')
        .convert(createWalletResponse.toJson());
    AppLogger.log("✅ Wallet creation Response:\n$prettyJson");

    return createWalletResponse;
  } catch (e, stack) {
    // Handle different exception types
    String message;
    if (e is DioException) {
      message = ErrorHandler.handleError(e);
    } else {
      message = e.toString();
    }
    AppLogger.log("❌ Error in wallet creation: $message\n$stack");
    throw (message);
  }
}

//FETCH PROMOTER REFERRALS (WALLET REGISTRATION)
Future<PromoterReferralsResponse> fetchPromoterReferrals({
  required String promoterPhone,
  int? page,
}) async {
  try {
    AppLogger.log("📤 Fetching promoter referrals for phone: $promoterPhone");

    // Use the correct endpoint base - should be wallet endpoint
    final url = "${ApiService.prodEndpointCreateWallet}/merchant-wallet/promoter-referrals";

    // Try POST method if GET returns 405
    final payload = {
      "search_filter": promoterPhone,
      "page": page ?? 1,
    };

    AppLogger.log("📦 Request Payload: $payload");

    final response = await _apiService.post(
      url,
      data: payload,
      requiresAuth: true,
    );

    // Parse the response using the PromoterReferralsResponse model
    final referralsResponse = PromoterReferralsResponse.fromJson(response.data);

    // Check backend error field
    if (referralsResponse.errors != null &&
        referralsResponse.errors!.isNotEmpty) {
      AppLogger.log("⚠️ Backend errors: ${referralsResponse.errors}");
      throw Exception(referralsResponse.errors!.first.toString());
    }

    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(referralsResponse.toJson());
    AppLogger.log("✅ Promoter referrals Response:\n$prettyJson");

    return referralsResponse;
  } catch (e, stack) {
    // Handle different exception types
    String message;
    if (e is DioException) {
      message = ErrorHandler.handleError(e);
    } else {
      message = e.toString();
    }
    AppLogger.log("❌ Error in fetching promoter referrals: $message\n$stack");
    throw (message);
  }
}
