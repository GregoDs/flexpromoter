import 'package:equatable/equatable.dart';
import 'package:flexpromoter/features/wallet/model/register_model/customer_reg_model.dart';
import 'package:flexpromoter/features/wallet/model/wallet_otp_model/wallet_otp_model.dart';
import 'package:flexpromoter/features/wallet/model/create_wallet_model/create_wallet_model.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletRegisterSuccess extends WalletState {
  final CustomerWalletRegResponse response;

  const WalletRegisterSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class WalletRegisterFailure extends WalletState {
  final String message;

  const WalletRegisterFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Add OTP verification states
class WalletVerifySuccess extends WalletState {
  final WalletOtpResponse response;

  const WalletVerifySuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class WalletVerifyFailure extends WalletState {
  final String message;

  const WalletVerifyFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Add wallet creation states
class WalletCreateSuccess extends WalletState {
  final CreateWalletResponse response;

  const WalletCreateSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class WalletCreateFailure extends WalletState {
  final String message;

  const WalletCreateFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
