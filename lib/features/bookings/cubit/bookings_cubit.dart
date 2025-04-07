import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/bookings/cubit/bookings_state.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/features/bookings/repo/bookings_repo.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final BookingsRepository _repository;
  BuildContext? _context;

  BookingsCubit({required BookingsRepository repository})
      : _repository = repository,
        super(const BookingsInitial());

  void setContext(BuildContext context) {
    _context = context;
  }

  // Fetch all bookings
  Future<void> fetchAllBookings() async {
    try {
      emit(const BookingsLoading());

      final bookings = await _repository.fetchAllBookings(0);

      // Even if we get an error, we'll show empty lists instead of null
      emit(BookingsLoaded.fromMap({
        'open': bookings['open'] ?? [],
        'closed': bookings['closed'] ?? [],
        'redeemed': bookings['redeemed'] ?? [],
        'unserviced': bookings['unserviced'] ?? [],
      }));
    } catch (e) {
      // Emit empty lists for the UI to show dashes
      emit(BookingsLoaded.fromMap({
        'open': [],
        'closed': [],
        'redeemed': [],
        'unserviced': [],
      }));

      // Show error message using custom scaffold
      if (_context != null) {
        String errorMessage = e.toString();
        // If the error message contains a response from the backend, extract it
        if (errorMessage.contains('Error fetching bookings:')) {
          errorMessage =
              errorMessage.replaceAll('Error fetching bookings:', '').trim();
        }

        CustomSnackBar.showError(
          _context!,
          title: 'Error Fetching Bookings',
          message: errorMessage,
        );
      }
    }
  }

  // Filter bookings by type
  void filterBookings(String type) {
    final currentState = state;
    if (currentState is BookingsLoaded) {
      List<Booking> filteredBookings;
      switch (type.toLowerCase()) {
        case 'open':
          filteredBookings = currentState.openBookings;
          break;
        case 'closed':
          filteredBookings = currentState.closedBookings;
          break;
        case 'redeemed':
          filteredBookings = currentState.redeemedBookings;
          break;
        case 'unserviced':
          filteredBookings = currentState.unservicedBookings;
          break;
        default:
          filteredBookings = [];
      }

      emit(BookingsFiltered(
        filteredBookings: filteredBookings,
        filterType: type,
      ));
    }
  }

  // Reset to initial state
  void reset() {
    emit(const BookingsInitial());
  }
}
