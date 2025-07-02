part of 'bkpayment_cubit.dart';

abstract class BKPaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BKPaymentInitial extends BKPaymentState {}

class BKPaymentLoading extends BKPaymentState {}

class BKPaymentSuccess extends BKPaymentState {
  final String message;
  BKPaymentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BKPaymentError extends BKPaymentState {
  final String error;
  BKPaymentError(this.error);

  @override
  List<Object?> get props => [error];
}
