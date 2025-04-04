import 'package:dio/dio.dart';
import 'package:flexpromoter/exports.dart';
import 'package:flexpromoter/utils/services/api_service.dart';
import 'package:flexpromoter/utils/services/error_handler.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart'
    as custom_snackbar;
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/features/auth/models/user_model.dart';

class CommissionRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> fetchCommissions({
    required String duration,
  }) async {
    try {
      // Get the stored user data
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        throw Exception('User data not found. Please login again.');
      }

      // Parse the stored user data
      final userModel = UserModel.fromJson(userData);
      final userId = userModel.user.id.toString();

      final response = await _apiService.post(
        '${ApiService.prodEndpointBookings}/promoters/commissions',
        data: {
          'user_id': userId,
          'duration': duration,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch commissions');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to handle errors and show snackbar
  void handleError(BuildContext context, dynamic error) {
    if (error is DioException) {
      final errorMessage = ErrorHandler.handleError(error);
      custom_snackbar.CustomSnackBar.showError(
        context,
        title: 'Error',
        message: errorMessage,
      );
    } else {
      custom_snackbar.CustomSnackBar.showError(
        context,
        title: 'Error',
        message: error.toString(),
      );
    }
  }
}
