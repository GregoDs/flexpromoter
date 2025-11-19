import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';
import 'package:flexpromoter/features/wallet/cubit/wallet_cubit.dart';
import 'package:flexpromoter/features/wallet/cubit/wallet_state.dart';
import 'package:flexpromoter/routes/app_routes.dart';

class RegisterWalletScreen extends StatefulWidget {
  const RegisterWalletScreen({super.key});

  @override
  State<RegisterWalletScreen> createState() => _RegisterWalletScreenState();
}

class _RegisterWalletScreenState extends State<RegisterWalletScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  bool _showValidationErrors = false;
  String? phoneError;
  String? merchantError;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> merchants = [
    {
      'name': 'Jaza Supermarket',
      'merchant_id': '812',
      'color': const Color(0xFF761B1A),
    },
    {
      'name': 'Quickmart Supermarket',
      'merchant_id': '347',
      'color': const Color(0xFF111111),
    },
    {
      'name': 'Naivas Supermarket',
      'merchant_id': '107',
      'color': const Color(0xFFFFB020),
    },
    {
      'name': 'HotPoint Appliances',
      'merchant_id': '73',
      'color': const Color(0xFFCD0000),
    },
    {
      'name': 'Azone Supermarket',
      'merchant_id': '727',
      'color': const Color(0xFF6C63FF),
    },
    {
      'name': 'Open Wallet',
      'merchant_id': '4',
      'color': const Color(0xFF00A86B),
    },
  ];

  String? selectedMerchantName;
  String? selectedMerchantId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    setState(() {
      String phoneText = phoneController.text.trim();

      if (phoneText.isEmpty) {
        phoneError = "Phone number is required";
      } else {
        // Remove leading zero if present
        if (phoneText.startsWith('0')) {
          phoneText = phoneText.substring(1);
        }

        // Check if it's a valid Kenyan phone number (7XXXXXXXX or 1XXXXXXXX)
        if (!RegExp(r'^(7|1)\d{8}$').hasMatch(phoneText)) {
          phoneError = "Enter a valid Kenyan phone number";
        } else {
          phoneError = null;
        }
      }
    });
  }

  void _validateMerchant() {
    setState(() {
      if (selectedMerchantName == null) {
        merchantError = "Please select a merchant";
      } else {
        merchantError = null;
      }
    });
  }

  void _submit() {
    setState(() {
      _showValidationErrors = true;
    });

    _validatePhone();
    _validateMerchant();

    if (phoneError == null && merchantError == null) {
      // Format phone number for API call
      String phoneText = phoneController.text.trim();

      // Remove leading zero if present
      if (phoneText.startsWith('0')) {
        phoneText = phoneText.substring(1);
      }

      // Format as 254XXXXXXXXX (without the + sign)
      String formattedPhone = "254$phoneText";

      // Trigger cubit registration
      context.read<WalletCubit>().registerCustomerWallet(
            phoneNumber: formattedPhone,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
        GoogleFonts.montserratTextTheme(Theme.of(context).textTheme);
    final fieldColor = Colors.white;
    final textColor = Colors.black87;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Register Customer",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: BlocListener<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletRegisterSuccess) {
            // Show success message
            CustomSnackBar.showSuccess(
              context,
              title: "Registration Initiated",
              message: "OTP sent successfully! Proceeding to verification...",
            );

            // Format phone number consistently for OTP screen (without + sign)
            String phoneText = phoneController.text.trim();
            if (phoneText.startsWith('0')) {
              phoneText = phoneText.substring(1);
            }
            String formattedPhone = "254$phoneText";

            // Navigate to OTP screen with arguments including merchant info
            Navigator.pushNamed(
              context,
              Routes.otpwalletscreen,
              arguments: {
                'phoneNumber': formattedPhone, // Remove the + prefix here
                'customerData': state.response.data,
                'merchantId': selectedMerchantId,
                'merchantName': selectedMerchantName,
              },
            );
          } else if (state is WalletRegisterFailure) {
            // Show error message
            CustomSnackBar.showError(
              context,
              title: "Registration Failed",
              message: state.message,
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    _buildHeader(textColor, textTheme),

                    SizedBox(height: 8.h),

                    // Step indicators
                    _buildStepIndicators(textColor),

                    SizedBox(height: 16.h),

                    // Reward info card
                    _buildRewardCard(textColor, textTheme),

                    SizedBox(height: 16.h),

                    // Phone number input
                    _buildPhoneInput(fieldColor, textColor, textTheme),

                    SizedBox(height: 16.h),

                    // Register button with BlocBuilder for loading state
                    BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        final isLoading = state is WalletLoading;
                        return _buildRegisterButton(isLoading, textTheme);
                      },
                    ),

                    SizedBox(height: 16.h),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorName.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.wallet,
                color: ColorName.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Register Customer",
                    style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "FlexPay Merchant Wallet",
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      color: ColorName.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          "Help your customer register for FlexPay merchant wallet and earn rewards together!",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.5,
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
            // Step 1
            _buildStepIndicator(
              stepNumber: "1",
              title: "Register",
              isActive: true,
              isCompleted: false,
            ),
            _buildStepConnector(isCompleted: false),

            // Step 2
            _buildStepIndicator(
              stepNumber: "2",
              title: "OTP Verify",
              isActive: false,
              isCompleted: false,
            ),
            _buildStepConnector(isCompleted: false),

            // Step 3
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
                color: isActive ? ColorName.primaryColor : Colors.grey[300]!,
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
              color: isActive ? ColorName.primaryColor : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
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

  Widget _buildRewardCard(Color textColor, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorName.primaryColor.withOpacity(0.1),
            ColorName.blue200.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorName.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorName.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Earn KSh 50 Cashback!",
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  "Both you and your customer get rewarded upon successful registration",
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput(
      Color fieldColor, Color textColor, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Merchant Dropdown
        Text(
          "Select Merchant",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 8.h),

        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: merchantError != null && _showValidationErrors
                ? Border.all(color: Colors.red, width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 4.h,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              value: selectedMerchantName,
              isExpanded: true,
              hint: Text(
                "Select merchant",
                style: GoogleFonts.montserrat(
                  color: Colors.grey[700],
                ),
              ),
              style: GoogleFonts.montserrat(
                color: textColor,
                fontSize: 14.sp,
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.blue[800],
              ),
              items: merchants.map((merchant) {
                return DropdownMenuItem<String>(
                  value: merchant['name'],
                  child: Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: merchant['color'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        merchant['name'],
                        style: GoogleFonts.montserrat(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                final selected = merchants.firstWhere(
                  (m) => m['name'] == value,
                );
                setState(() {
                  selectedMerchantName = selected['name'];
                  selectedMerchantId = selected['merchant_id'];
                });

                if (_showValidationErrors) _validateMerchant();
              },
            ),
          ),
        ),

        // Merchant error message
        if (merchantError != null && _showValidationErrors)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  merchantError!,
                  style: GoogleFonts.montserrat(
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

        SizedBox(height: 20.h),

        // Phone number section
        Text(
          "Phone number",
          style: GoogleFonts.montserrat(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            // Country code container
            Container(
              height: 36.h,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: fieldColor,
                border: Border.all(color: Colors.grey[400]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Kenya flag
                  Container(
                    width: 28,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/kenya.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "+254",
                    style: GoogleFonts.montserrat(
                      color: textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Phone number field
            Expanded(
              child: Container(
                height: 38.h,
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: fieldColor,
                    hintText: "Enter phone number...",
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.grey[500],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: phoneError != null && _showValidationErrors
                            ? Colors.red
                            : Colors.grey[400]!,
                        width: phoneError != null && _showValidationErrors
                            ? 1.5
                            : 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: phoneError != null && _showValidationErrors
                            ? Colors.red
                            : Colors.grey[400]!,
                        width: phoneError != null && _showValidationErrors
                            ? 1.5
                            : 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: phoneError != null && _showValidationErrors
                            ? Colors.red
                            : ColorName.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  onChanged: (_) {
                    if (_showValidationErrors) _validatePhone();
                  },
                ),
              ),
            ),
          ],
        ),

        // Phone error message
        if (phoneError != null && _showValidationErrors)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  phoneError!,
                  style: GoogleFonts.montserrat(
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRegisterButton(bool isLoading, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorName.primaryColor,
          disabledBackgroundColor: ColorName.buttonDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: isLoading ? null : _submit,
        child: isLoading
            ? const SpinKitThreeBounce(
                color: Colors.white,
                size: 24,
              )
            : Text(
                "Register",
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
