import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flexpromoter/routes/app_routes.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';
import 'package:flexpromoter/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flexpromoter/features/auth/cubit/auth_cubit.dart';
import 'package:flexpromoter/features/auth/cubit/auth_state.dart';
import 'package:flexpromoter/features/auth/repo/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  String? _phoneNumber;
  bool _isLoading = false;
  bool _isSnackBarShowing = false;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneNumber = prefs.getString('phone_number');
    });
  }

  void onOtpCompleted(String otp) {
    if (_phoneNumber != null) {
      setState(() {
        _isLoading = true;
      });
      authCubit.verifyOtp(_phoneNumber!, otp);
    }
  }

  void _resendOtp() {
    if (_phoneNumber != null) {
      authCubit.requestOtp(_phoneNumber!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final availableHeight = size.height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: ColorName.whiteColor,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUserUpdated) {
              Navigator.pushReplacementNamed(context, Routes.home);
            } else if (state is AuthError && !_isSnackBarShowing) {
              setState(() {
                _isSnackBarShowing = true;
              });

              CustomSnackBar.showError(
                context,
                title: 'Error',
                message: state.errorMessage,
                actionLabel: 'Dismiss',
                onAction: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  setState(() {
                    _isSnackBarShowing = false;
                  });
                },
              );
            }
            setState(() {
              _isLoading = false;
            });
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                height: availableHeight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Lottie.asset(
                        "assets/images/otpver.json",
                        height: availableHeight * 0.3,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: ColorName.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: ColorName.primaryColor,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Enter the OTP sent to",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorName.mainGrey,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _phoneNumber ?? "+00-0000-000-0000",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorName.blackColor,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 32),
                    PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 65,
                        fieldWidth: 60,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        activeColor: ColorName.primaryColor,
                        inactiveColor: ColorName.lightGrey,
                        selectedColor: ColorName.primaryColor,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorName.blackColor,
                        fontFamily: 'Montserrat',
                      ),
                      cursorColor: ColorName.primaryColor,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      onCompleted: (otp) {
                        onOtpCompleted(otp);
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: _resendOtp,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh,
                              size: 18, color: ColorName.blue200),
                          SizedBox(width: 8),
                          Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: ColorName.blue200,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
