import 'package:flexpromoter/features/auth/models/user_model.dart';
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
      final userModel = UserModel.fromJson(userData);

      // Handle nullable promoterId properly
      final promoterId = userModel.user.promoterId;
      if (promoterId == null) {
        AppLogger.log("❌ Promoter ID not found in user data");
        emit(const WalletCreateFailure(
            message: "Promoter ID not available. Please login again."));
        return;
      }

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

  /// Fetch promoter referrals
  /// This method automatically retrieves promoter phone from shared preferences
  Future<void> fetchPromoterReferrals({
    int? page,
  }) async {
    try {
      emit(const WalletLoading());

      AppLogger.log("📞 Starting referrals fetch");

      // Get promoter phone from shared preferences
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        throw Exception('User Data not found. Please Login and try again');
      }
      final userModel = UserModel.fromJson(userData);
      final promoterPhone = userModel.user.phoneNumber.toString();
      // const userId = '141192';

      AppLogger.log("Logging user data: $userData for referrals fetch");

      AppLogger.log(
          "📱 Using promoter phone: $promoterPhone for referrals fetch");

      final response = await wallet_repo.fetchPromoterReferrals(
        promoterPhone: promoterPhone,
        page: page,
      );

      // Check if referrals fetch was successful
      if (response.success && response.statusCode == 200) {
        AppLogger.log("✅ Promoter referrals fetch successful");
        emit(WalletReferralsSuccess(response: response));
      } else {
        // Handle backend errors
        String errorMessage = "Failed to fetch referrals";
        if (response.errors != null && response.errors!.isNotEmpty) {
          errorMessage = response.errors!.join(', ');
        }
        AppLogger.log("❌ Promoter referrals fetch failed: $errorMessage");
        emit(WalletReferralsFailure(message: errorMessage));
      }
    } catch (e) {
      AppLogger.log("❌ Promoter referrals fetch error: $e");
      emit(WalletReferralsFailure(message: e.toString()));
    }
  }
}
