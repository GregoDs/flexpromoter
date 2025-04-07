import 'package:flexpromoter/features/bookings/models/bookings_model.dart';

sealed class BookingsState {
  const BookingsState();
}

// Initial state
class BookingsInitial extends BookingsState {
  const BookingsInitial();
}

// Loading states
class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

// Success states
class BookingsLoaded extends BookingsState {
  final Map<String, List<Booking>> bookings;
  final List<Booking> openBookings;
  final List<Booking> closedBookings;
  final List<Booking> redeemedBookings;
  final List<Booking> unservicedBookings;

  const BookingsLoaded({
    required this.bookings,
    required this.openBookings,
    required this.closedBookings,
    required this.redeemedBookings,
    required this.unservicedBookings,
  });

  factory BookingsLoaded.fromMap(Map<String, List<Booking>> bookingsMap) {
    return BookingsLoaded(
      bookings: bookingsMap,
      openBookings: bookingsMap['open'] ?? [],
      closedBookings: bookingsMap['closed'] ?? [],
      redeemedBookings: bookingsMap['redeemed'] ?? [],
      unservicedBookings: bookingsMap['unserviced'] ?? [],
    );
  }
}

// Error states
class BookingsError extends BookingsState {
  final String message;
  const BookingsError(this.message);
}

// Empty states
class BookingsEmpty extends BookingsState {
  const BookingsEmpty();
}

// Filter states
class BookingsFiltered extends BookingsState {
  final List<Booking> filteredBookings;
  final String filterType;

  const BookingsFiltered({
    required this.filteredBookings,
    required this.filterType,
  });
}
