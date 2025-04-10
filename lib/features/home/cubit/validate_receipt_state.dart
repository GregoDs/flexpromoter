import 'package:flutter/foundation.dart';

@immutable
sealed class ValidateReceiptState {
  const ValidateReceiptState();
}

final class ValidateReceiptInitial extends ValidateReceiptState {
  const ValidateReceiptInitial();
}

final class ValidateReceiptLoading extends ValidateReceiptState {
  const ValidateReceiptLoading();
}

final class ValidateReceiptSuccess extends ValidateReceiptState {
  final Map<String, dynamic> data;
  const ValidateReceiptSuccess(this.data);
}

final class ValidateReceiptError extends ValidateReceiptState {
  final String message;
  const ValidateReceiptError(this.message);
}
