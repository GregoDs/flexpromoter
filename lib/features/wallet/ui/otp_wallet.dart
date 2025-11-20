import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';
import 'package:flexpromoter/features/wallet/ui/success_page.dart';
import 'package:flexpromoter/features/wallet/cubit/wallet_cubit.dart';
import 'package:flexpromoter/features/wallet/cubit/wallet_state.dart';
import 'package:flexpromoter/features/wallet/model/register_model/customer_reg_model.dart';
import 'dart:async';

class OtpWalletScreen extends StatefulWidget {
  final String phoneNumber;
  final CustomerData? customerData;
  final String? merchantId;
  final String? merchantName;

  const OtpWalletScreen({
    super.key,
    required this.phoneNumber,
    this.customerData,
    this.merchantId,
    this.merchantName,
  });

  @override
  State<OtpWalletScreen> createState() => _OtpWalletScreenState();
}

class _OtpWalletScreenState extends State<OtpWalletScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> otpControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  late AnimationController _animationController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _shakeAnimation;

  Timer? _timer;
  int _resendCountdown = 10;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _animationController.forward();
    _startResendTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shakeController.dispose();
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }

    String completeOtp = otpControllers.map((c) => c.text).join();
    if (completeOtp.length == 4) {
      _verifyOtp();
    }
  }

  void _verifyOtp() {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      context.read<WalletCubit>().verifyCustomerOtp(
            phoneNumber: widget.phoneNumber,
            otp: otp,
          );
    }
  }

  void _clearOtp() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(focusNodes[0]);
  }

  void _shakeOtpFields() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  void _resendOtp() async {
    if (_canResend) {
      context.read<WalletCubit>().registerCustomerWallet(
            phoneNumber: widget.phoneNumber,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final textTheme =
        GoogleFonts.montserratTextTheme(Theme.of(context).textTheme);
    final fieldColor = isDark ? Colors.grey[850]! : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Verify OTP",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: BlocListener<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletVerifySuccess) {
            CustomSnackBar.showSuccess(
              context,
              title: "Verification Successful",
              message: "Creating wallet...",
            );

            // Pass required data to cubit for automatic wallet creation
            final customerId =
                widget.customerData?.userId ?? widget.customerData?.id;

            if (customerId != null && widget.merchantId != null) {
              context.read<WalletCubit>().createWalletAfterOtpVerification(
                    merchantId: widget.merchantId!,
                    customerId: customerId,
                    phoneNumber: widget.phoneNumber,
                  );
            } else {
              CustomSnackBar.showError(
                context,
                title: "Missing Data",
                message:
                    "Customer or merchant information missing. Please try again.",
              );
            }
          } else if (state is WalletVerifyFailure) {
            CustomSnackBar.showError(
              context,
              title: "Verification Failed",
              message: state.message,
            );
            _shakeOtpFields();
            _clearOtp();
          } else if (state is WalletCreateSuccess) {
            CustomSnackBar.showSuccess(
              context,
              title: "Wallet Created Successfully",
              message: "Proceeding to STK push...",
            );

            Future.delayed(const Duration(milliseconds: 1000), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ClaimRewardSuccessPage(
                    phoneNumber: widget.phoneNumber,
                    rewardAmount: "KSh 50",
                  ),
                ),
              );
            });
          } else if (state is WalletCreateFailure) {
            CustomSnackBar.showError(
              context,
              title: "Wallet Creation Failed",
              message: state.message,
            );
          } else if (state is WalletRegisterSuccess) {
            CustomSnackBar.showSuccess(
              context,
              title: "OTP Resent",
              message: "A new OTP has been sent to ${widget.phoneNumber}",
            );
            _startResendTimer();
            _clearOtp();
          } else if (state is WalletRegisterFailure) {
            CustomSnackBar.showError(
              context,
              title: "Resend Failed",
              message: state.message,
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100.h,
                      child: Lottie.asset(
                        'assets/images/otpver.json',
                        height: 140.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    _buildHeader(textColor, textTheme),
                    SizedBox(height: 32.h),
                    _buildStepIndicators(textColor),
                    SizedBox(height: 32.h),
                    SlideTransition(
                      position: _shakeAnimation,
                      child: BlocBuilder<WalletCubit, WalletState>(
                        builder: (context, state) {
                          final isLoading = state is WalletLoading;
                          return _buildOtpInput(
                              fieldColor, textColor, textTheme, isLoading);
                        },
                      ),
                    ),
                    SizedBox(height: 32.h),
                    BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        final isLoading = state is WalletLoading;
                        return _buildVerifyButton(isLoading, textTheme);
                      },
                    ),
                    SizedBox(height: 24.h),
                    BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        final isResendLoading = state is WalletLoading;
                        return _buildResendSection(
                            textColor, textTheme, isResendLoading);
                      },
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, TextTheme textTheme) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Text(
          "Enter Verification Code",
          style: GoogleFonts.montserrat(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              const TextSpan(
                  text: "We've sent a 4-digit verification code to\n"),
              TextSpan(
                text: widget.phoneNumber,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: ColorName.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicators(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Registration Process",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildStepIndicator(
              stepNumber: "1",
              title: "Register",
              isActive: false,
              isCompleted: true,
            ),
            _buildStepConnector(isCompleted: true),
            _buildStepIndicator(
              stepNumber: "2",
              title: "OTP Verify",
              isActive: true,
              isCompleted: false,
            ),
            _buildStepConnector(isCompleted: false),
            _buildStepIndicator(
              stepNumber: "3",
              title: "Claim Reward",
              isActive: false,
              isCompleted: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepIndicator({
    required String stepNumber,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isActive
                  ? ColorName.primaryColor
                  : isCompleted
                      ? ColorName.primaryColor
                      : Colors.grey[300],
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? ColorName.primaryColor
                    : isCompleted
                        ? ColorName.primaryColor
                        : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      stepNumber,
                      style: GoogleFonts.montserrat(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              color: isActive
                  ? ColorName.primaryColor
                  : isCompleted
                      ? ColorName.primaryColor
                      : Colors.grey[600],
              fontWeight:
                  isActive || isCompleted ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector({required bool isCompleted}) {
    return Container(
      width: 30.w,
      height: 2,
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: isCompleted ? ColorName.primaryColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildOtpInput(
      Color fieldColor, Color textColor, TextTheme textTheme, bool isLoading) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: otpControllers[index].text.isNotEmpty
                      ? ColorName.primaryColor
                      : Colors.grey[400]!,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: otpControllers[index],
                focusNode: focusNodes[index],
                enabled: !isLoading,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: GoogleFonts.montserrat(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: (value) => _onOtpChanged(value, index),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildResendSection(
      Color textColor, TextTheme textTheme, bool isResendLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        if (isResendLoading)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          GestureDetector(
            onTap: _canResend ? _resendOtp : null,
            child: Text(
              _canResend ? "Resend" : "Resend in ${_resendCountdown}s",
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                color: _canResend ? ColorName.primaryColor : Colors.grey[500],
                fontWeight: FontWeight.w600,
                decoration: _canResend ? TextDecoration.underline : null,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVerifyButton(bool isLoading, TextTheme textTheme) {
    String otp = otpControllers.map((c) => c.text).join();
    bool isOtpComplete = otp.length == 4;

    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isOtpComplete ? ColorName.primaryColor : ColorName.buttonDisabled,
          disabledBackgroundColor: ColorName.buttonDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: (isLoading || !isOtpComplete) ? null : _verifyOtp,
        child: isLoading
            ? const SpinKitThreeBounce(
                color: Colors.white,
                size: 24,
              )
            : Text(
                "Verify & Complete",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.sp,
                ),
              ),
      ),
    );
  }
}
