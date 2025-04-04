import 'package:bloc/bloc.dart';
import 'package:flexpromoter/features/commissions/repo/commission_repo.dart';
import 'package:flutter/material.dart';

part 'commissions_state.dart';

class CommissionsCubit extends Cubit<CommissionsState> {
  final CommissionRepository _repository;

  CommissionsCubit({
    required CommissionRepository repository,
  })  : _repository = repository,
        super(CommissionsInitial());

  Future<void> fetchCommissions(BuildContext context, String duration) async {
    try {
      emit(CommissionsLoading());

      final response = await _repository.fetchCommissions(
        duration: duration,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;

        emit(CommissionsSuccess(
          totalCommissions: (data['totalCommissions'] as num).toDouble(),
          deficit: (data['deficit'] as num).toDouble(),
          duration: duration,
        ));
      } else {
        final errorMessage =
            response['errors']?.first ?? 'Failed to fetch commissions';
        _repository.handleError(context, Exception(errorMessage));
        emit(CommissionsError(errorMessage));
      }
    } catch (e) {
      _repository.handleError(context, e);
      emit(CommissionsError(e.toString()));
    }
  }

  // Helper method to get duration string
  String getDurationString(String duration) {
    switch (duration.toLowerCase()) {
      case 'week':
        return 'This Week';
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      default:
        return 'Custom Period';
    }
  }
}
