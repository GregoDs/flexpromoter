import 'package:flexpromoter/features/leaderboard/models/leaderboard_model.dart';
import 'package:meta/meta.dart';

@immutable
sealed class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardModel> leaderboardData;

  LeaderboardLoaded(this.leaderboardData);
}

class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError(this.message);
}
