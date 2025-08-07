import 'dart:developer' as developer;
import 'package:flexpromoter/exports.dart' hide CustomSnackBar;
import 'package:flexpromoter/utils/services/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'validate_receipt_state.dart';
import '../models/validate_model.dart';
import '../repo/home_repo.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';

class ValidateReceiptCubit extends Cubit<ValidateReceiptState> {
  final HomeRepo _homeRepo;
  final BuildContext context;

  ValidateReceiptCubit(this._homeRepo, this.context)
      : super(const ValidateReceiptInitial());

  Future<void> validateReceipt(ValidateReceiptModel model) async {
  developer.log('Validating receipt with slip: ${model.slipNo}');
  emit(const ValidateReceiptLoading());

  try {
    final response = await _homeRepo.validateReceipt(slipNo: model.slipNo);

    developer.log('✅ Receipt validation successful: $response');

    CustomSnackBar.showSuccess(
      context,
      title: 'Success',
      message: 'Receipt validated successfully!',
    );

    emit(ValidateReceiptSuccess(response));
  } on DioException catch (dioError) {
    final message = ErrorHandler.handleError(dioError);
    developer.log('❌ Dio error: $message');

    CustomSnackBar.showError(
      context,
      title: 'Validation Failed',
      message: message,
    );

    emit(ValidateReceiptError(message));
  } catch (e) {
    developer.log('❌ Unknown error: $e');

    CustomSnackBar.showError(
      context,
      title: 'Error',
      message: e.toString().replaceAll('Exception: ', ''),
    );

    emit(ValidateReceiptError(e.toString()));
  }
}
}
