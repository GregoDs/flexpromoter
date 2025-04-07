import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/leaderboard/cubit/leaderboard_state.dart';
import 'package:flexpromoter/features/leaderboard/repo/leaderboard_repository.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final LeaderboardRepository _repository;

  LeaderboardCubit({required LeaderboardRepository repository})
      : _repository = repository,
        super(LeaderboardInitial());

  Future<void> fetchLeaderboardData() async {
    try {
      emit(LeaderboardLoading());
      final leaderboardData = await _repository.getLeaderboardData();
      emit(LeaderboardLoaded(leaderboardData));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }
}
