import 'package:flexpromoter/exports.dart';
import 'package:flexpromoter/utils/services/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/bookings/repo/bookings_repo.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/features/bookings/cubit/bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final BookingsRepository _repository;

  BookingsCubit(this._repository, {required BookingsRepository repository})
      : super(BookingsInitial());

  // Add this mapping function
  String _mapTagToBackendType(String tag) {
    switch (tag.toLowerCase()) {
      case 'active':
        return 'open';
      case 'completed':
        return 'closed';
      case 'redeemed':
        return 'redeemed';
      case 'unserviced':
        return 'unserviced';
      default:
        return tag.toLowerCase();
    }
  }

  Future<void> fetchBookingsByType(String type, {int page = 1}) async {
    emit(BookingsLoading());

    try {
      final backendType = _mapTagToBackendType(type);
      Map<String, dynamic> result;
      switch (backendType) {
        case 'open':
          result = await _repository.fetchOpenBookings(page: page);
          break;
        case 'closed':
          result = await _repository.fetchClosedBookings(page: page);
          break;
        case 'redeemed':
          result = await _repository.fetchRedeemedBookings(page: page);
          break;
        case 'unserviced':
          result = await _repository.fetchUnservicedBookings(page: page);
          break;
        default:
          result = {'bookings': <Booking>[], 'totalPages': 1};
      }

      emit(BookingsLoaded(
        bookings: result['bookings'] as List<Booking>,
        bookingType: type,
        totalPages: result['totalPages'] as int,
      ));
    } catch (e) {
      emit(BookingsError('Failed to load $type bookings. ${e.toString()}'));
    }
  }

  Future<void> searchCustomerBookings({
    required String phoneNumber,
    required String bookingType,
    int page = 1,
  }) async {
    emit(CustomerBookingsSearchLoading());
    try {
      final backendType = _mapTagToBackendType(bookingType);
      final result = await _repository.searchCustomerBookings(
        phoneNumber: phoneNumber,
        bookingType: backendType,
        page: page,
      );
      emit(CustomerBookingsSearchLoaded(
        bookings: result['bookings'] as List<Booking>,
        bookingType: bookingType,
        totalPages: result['totalPages'] as int,
      ));
    } catch (e) {
      emit(CustomerBookingsSearchError(ErrorHandler.handleError(
        e is DioException
            ? e
            : DioException(requestOptions: RequestOptions(path: '')),
      )));
    }
  }
}
