import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/wallet/cubit/wallet_state.dart';
import 'package:flexpromoter/features/wallet/repo/wallet_repo.dart'
    as wallet_repo;
import 'package:flexpromoter/utils/services/logger.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(const WalletInitial());

  /// Register customer wallet with phone number
  Future<void> registerCustomerWallet({
    required String phoneNumber,
  }) async {
    try {
      emit(const WalletLoading());

      AppLogger.log("🏦 Starting wallet registration for phone: $phoneNumber");

      final response =
          await wallet_repo.registerCustomerWallet(phoneNumber: phoneNumber);

      // Check if registration was successful
      if (response.success && response.statusCode == 200) {
        AppLogger.log("✅ Wallet registration successful");
        emit(WalletRegisterSuccess(response: response));
      } else {
        // Handle backend errors
        String errorMessage = "Registration failed";
        if (response.errors != null && response.errors!.isNotEmpty) {
          errorMessage = response.errors!.join(', ');
        }
        AppLogger.log("❌ Wallet registration failed: $errorMessage");
        emit(WalletRegisterFailure(message: errorMessage));
      }
    } catch (e) {
      AppLogger.log("❌ Wallet registration error: $e");
      emit(WalletRegisterFailure(message: e.toString()));
    }
  }

  /// Verify customer OTP
  Future<void> verifyCustomerOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      emit(const WalletLoading());

      AppLogger.log("🔐 Starting OTP verification for phone: $phoneNumber");

      final response = await wallet_repo.verifyCustomerOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );

      // Check if verification was successful
      if (response.success && response.statusCode == 200) {
        AppLogger.log("✅ OTP verification successful");
        emit(WalletVerifySuccess(response: response));
      } else {
        // Handle backend errors
        String errorMessage = "OTP verification failed";
        if (response.errors != null && response.errors!.isNotEmpty) {
          errorMessage = response.errors!.join(', ');
        }
        AppLogger.log("❌ OTP verification failed: $errorMessage");
        emit(WalletVerifyFailure(message: errorMessage));
      }
    } catch (e) {
      AppLogger.log("❌ OTP verification error: $e");
      emit(WalletVerifyFailure(message: e.toString()));
    }
  }

  /// Create customer wallet after successful OTP verification
  Future<void> createCustomerWallet({
    required String merchantId,
    required int customerId,
    required int promoterId,
    String bookingSource = "promoter_app",
  }) async {
    try {
      emit(const WalletLoading());

      AppLogger.log("🏪 Creating customer wallet for merchant: $merchantId");

      final response = await wallet_repo.createCustomerWallet(
        merchantId: merchantId,
        customerId: customerId,
        promoterId: promoterId,
        bookingSource: bookingSource,
      );

      // Check if wallet creation was successful
      if (response.success && response.statusCode == 200) {
        AppLogger.log("✅ Wallet creation successful");
        emit(WalletCreateSuccess(response: response));
      } else {
        // Handle backend errors
        String errorMessage = "Wallet creation failed";
        if (response.errors != null && response.errors!.isNotEmpty) {
          errorMessage = response.errors!.join(', ');
        }
        AppLogger.log("❌ Wallet creation failed: $errorMessage");
        emit(WalletCreateFailure(message: errorMessage));
      }
    } catch (e) {
      AppLogger.log("❌ Wallet creation error: $e");
      emit(WalletCreateFailure(message: e.toString()));
    }
  }

  /// Create customer wallet after successful OTP verification
  /// This method automatically retrieves promoter data and creates the wallet
  Future<void> createWalletAfterOtpVerification({
    required String merchantId,
    required int customerId,
    required String phoneNumber,
    String bookingSource = "app",
  }) async {
    try {
      AppLogger.log(
          "🔄 Starting automatic wallet creation after OTP verification");

      // Get promoter data from shared preferences
      final userData = await SharedPreferencesHelper.getUserData();

      if (userData == null) {
        AppLogger.log("❌ User data not found in shared preferences");
        emit(const WalletCreateFailure(
            message: "User information not available. Please login again."));
        return;
      }

      AppLogger.log("📱 Retrieved user data: ${userData.toString()}");

      // Extract promoter ID from user data structure
      int? promoterId;

      // Handle different user data structures
      if (userData['data'] != null) {
        final dataObj = userData['data'];

        // Check if data is an array (from OTP verification response)
        if (dataObj is List<dynamic>) {
          AppLogger.log("📋 Processing array-based data structure");

          // Look for promoter data in the array (usually second object)
          for (var item in dataObj) {
            if (item is Map<String, dynamic>) {
              // Check if this object has promoter-specific fields
              if (item.containsKey('user_id') &&
                  item.containsKey('first_name')) {
                promoterId = item['id'] as int?;
                AppLogger.log(
                    "👤 Found promoter ID in data array: $promoterId");
                break;
              }
              // Fallback to user ID if no promoter data found
              if (item.containsKey('id') && !item.containsKey('user_id')) {
                promoterId = item['id'] as int?;
                AppLogger.log("👤 Using user ID as fallback: $promoterId");
              }
            }
          }
        }
        // Check if data is an object (from login response)
        else if (dataObj is Map<String, dynamic>) {
          AppLogger.log("📋 Processing object-based data structure");

          // Check if there's a nested user object
          if (dataObj.containsKey('user') &&
              dataObj['user'] is Map<String, dynamic>) {
            final userObj = dataObj['user'] as Map<String, dynamic>;
            promoterId = userObj['id'] as int?;
            AppLogger.log("👤 Found promoter ID in user object: $promoterId");
          } else {
            // Direct ID in the data object
            promoterId = dataObj['id'] as int?;
            AppLogger.log("👤 Found promoter ID in data object: $promoterId");
          }
        }
      } else {
        // Direct structure fallback
        promoterId = userData['id'] as int?;
        AppLogger.log("👤 Using direct ID structure: $promoterId");
      }

      if (promoterId == null) {
        AppLogger.log("❌ Promoter ID not found in user data structure");
        emit(const WalletCreateFailure(
            message: "Promoter ID not available. Please login again."));
        return;
      }

      AppLogger.log("👤 Using promoter ID: $promoterId for wallet creation");

      // Call the existing create wallet method
      await createCustomerWallet(
        merchantId: merchantId,
        customerId: customerId,
        promoterId: promoterId,
        bookingSource: bookingSource,
      );
    } catch (e) {
      AppLogger.log("❌ Automatic wallet creation error: $e");
      emit(WalletCreateFailure(message: e.toString()));
    }
  }
}
