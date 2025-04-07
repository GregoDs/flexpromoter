import 'package:flexpromoter/exports.dart';
import 'package:flexpromoter/features/auth/models/user_model.dart';
import 'package:flexpromoter/features/leaderboard/models/leaderboard_model.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/utils/services/api_service.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart'
    as custom_snackbar;

class LeaderboardRepository {
  final ApiService _apiService = ApiService();

  Future<List<LeaderboardModel>> getLeaderboardData() async {
    try {
      //get user id from shared preferences
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        throw Exception('User Data not found. Please Login and try again');
      }
      //parse user data
      final userModel = UserModel.fromJson(userData);
      final userId = userModel.user.id.toString();

      
      final response = await _apiService.get(
        '${ApiService.prodEndpointBookings}/promoters/top/$userId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((item) => LeaderboardModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load leaderboard data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LeaderboardModel>> fetchLeaderboardData(
      BuildContext context) async {
    try {
      final leaderboardData = await getLeaderboardData();
      return leaderboardData;
    } catch (e) {
      custom_snackbar.CustomSnackBar.showError(
        context,
        title: 'Error',
        message: e.toString(),
      );
      rethrow;
    }
  }
}
