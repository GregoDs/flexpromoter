part of 'commissions_cubit.dart';

@immutable
sealed class CommissionsState {}

final class CommissionsInitial extends CommissionsState {}

final class CommissionsLoading extends CommissionsState {}

final class CommissionsSuccess extends CommissionsState {
  final double totalCommissions;
  final double deficit;
  final String duration;

  CommissionsSuccess({
    required this.totalCommissions,
    required this.deficit,
    required this.duration,
  });
}

final class CommissionsError extends CommissionsState {
  final String message;

  CommissionsError(this.message);
}
