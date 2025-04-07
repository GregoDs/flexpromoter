import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/bookings/models/make_bookings_model.dart';
import 'package:flexpromoter/features/bookings/repo/bookings_repo.dart';

// States
abstract class MakeBookingState {}

class MakeBookingInitial extends MakeBookingState {}

class MakeBookingLoading extends MakeBookingState {}

class MakeBookingSuccess extends MakeBookingState {}

class MakeBookingError extends MakeBookingState {
  final String message;
  MakeBookingError(this.message);
}

// Cubit
class MakeBookingCubit extends Cubit<MakeBookingState> {
  final BookingsRepository _repository;

  MakeBookingCubit(this._repository) : super(MakeBookingInitial());

  Future<void> createBooking(
      BuildContext context, BookingRequestModel bookingRequest) async {
    emit(MakeBookingLoading());
    try {
      final success = await _repository.createBooking(context, bookingRequest);
      if (success) {
        emit(MakeBookingSuccess());
      } else {
        emit(MakeBookingError('Failed to create booking'));
      }
    } catch (e) {
      emit(MakeBookingError(e.toString()));
    }
  }
}
