import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/features/bookings/repo/bookings_repo.dart';

part 'bkpayment_state.dart';

class BKPaymentCubit extends Cubit<BKPaymentState> {
  final BookingsRepository bookingsRepository;

  BKPaymentCubit({required this.bookingsRepository})
      : super(BKPaymentInitial());

  Future<void> promptPayment(PromptBookingPaymentRequest request) async {
    emit(BKPaymentLoading());
    try {
      final response = await bookingsRepository.promptBookingPayment(request);
      if (response.success) {
        emit(BKPaymentSuccess(response.message));
      } else {
        // If the response is not successful, emit the error message
        emit(BKPaymentError(response.message));
      }
    } catch (e) {
      // If the exception has a message, use it; otherwise, use a generic error
      String errorMsg = e.toString();
      if (e is Exception && e.toString().startsWith('Exception: ')) {
        errorMsg = e.toString().replaceFirst('Exception: ', '');
      }
      emit(BKPaymentError(errorMsg));
    }
  }
}
