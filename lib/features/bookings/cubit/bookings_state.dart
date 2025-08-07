import 'package:equatable/equatable.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<Booking> bookings;
  final String bookingType;
  final int totalPages;

  const BookingsLoaded({
    required this.bookings,
    required this.bookingType,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [bookings, bookingType, totalPages];
}

class BookingsError extends BookingsState {
  final String message;

  const BookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CustomerBookingsSearchLoading extends BookingsState {}

class CustomerBookingsSearchLoaded extends BookingsState {
  final List<Booking> bookings;
  final String bookingType;
  final int totalPages;

  const CustomerBookingsSearchLoaded({
    required this.bookings,
    required this.bookingType,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [bookings, bookingType, totalPages];
}

class CustomerBookingsSearchError extends BookingsState {
  final String message;

  const CustomerBookingsSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
