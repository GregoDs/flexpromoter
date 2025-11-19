import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:flexpromoter/gen/colors.gen.dart';
import 'dart:async';

class ClaimRewardSuccessPage extends StatefulWidget {
  final String phoneNumber;
  final String rewardAmount;

  const ClaimRewardSuccessPage({
    super.key,
    required this.phoneNumber,
    this.rewardAmount = "KSh 50",
  });

  @override
  State<ClaimRewardSuccessPage> createState() => _ClaimRewardSuccessPageState();
}

class _ClaimRewardSuccessPageState extends State<ClaimRewardSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  bool _showContent = false;

  @override
  void initState() {
    super.initState();

    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
          parent: _mainAnimationController, curve: Curves.bounceOut),
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Start fade in
    _fadeController.forward();

    // Wait a bit then show content
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _showContent = true;
    });

    // Start slide animation
    _slideController.forward();

    // Wait then start scale animation
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();

    // Start main bounce animation
    await Future.delayed(const Duration(milliseconds: 200));
    _mainAnimationController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header with close button
                _buildHeader(textColor),

                // Main content
                Expanded(
                  child: _showContent
                      ? SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Success animation
                              _buildSuccessAnimation(),

                              SizedBox(height: 32.h),

                              // Success message
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: _buildSuccessMessage(textColor),
                              ),

                              SizedBox(height: 32.h),

                              // Action buttons
                              _buildActionButtons(),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40), // Spacer for centering
        Text(
          "Reward Claimed!",
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        IconButton(
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          icon: Icon(
            Icons.close,
            color: Colors.grey[600],
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessAnimation() {
    return Container(
      height: 200.h,
      width: 200.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle with gradient
          Container(
            height: 180.h,
            width: 180.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ColorName.primaryColor.withOpacity(0.1),
                  ColorName.blue200.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Lottie animation
          Lottie.asset(
            'assets/images/success.json',
            height: 160.h,
            fit: BoxFit.contain,
            repeat: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage(Color textColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.celebration,
              color: ColorName.primaryColor,
              size: 28,
            ),
            SizedBox(width: 8.w),
            Text(
              "Congratulations!",
              style: GoogleFonts.montserrat(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          "Customer registration completed successfully!",
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          "Both rewards have been processed and sent to your M-Pesa accounts.",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: Colors.grey[500],
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRewardCard(Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorName.primaryColor,
            ColorName.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorName.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Reward icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 32,
            ),
          ),

          SizedBox(height: 16.h),

          // Reward amount
          Text(
            widget.rewardAmount,
            style: GoogleFonts.montserrat(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 8.h),

          // Reward description
          Text(
            "Cashback Reward",
            style: GoogleFonts.montserrat(
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 16.h),

          // Divider
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withOpacity(0.3),
          ),

          SizedBox(height: 16.h),

          // Phone numbers
          Row(
            children: [
              Expanded(
                child: _buildRecipientInfo(
                  "You",
                  widget.phoneNumber,
                  widget.rewardAmount,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildRecipientInfo(
                  "Customer",
                  widget.phoneNumber,
                  widget.rewardAmount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientInfo(String label, String phone, String amount) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          amount,
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorName.blue200.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorName.blue200.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorName.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.phone_android,
                  color: ColorName.primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  "Check M-Pesa Balance",
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "Your ${widget.rewardAmount} cashback has been sent to your M-Pesa account. Please check your balance by dialing *144# or check your M-Pesa messages to confirm receipt.",
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary button - Check M-Pesa
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorName.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: ColorName.primaryColor.withOpacity(0.3),
            ),
            onPressed: () {
              // TODO: Open dialer with *144# or show instructions
              _showMpesaInstructions();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Check M-Pesa Balance",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Secondary button - Go Home
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: ColorName.primaryColor,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  color: ColorName.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Go Back Home",
                  style: GoogleFonts.montserrat(
                    color: ColorName.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMpesaInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: ColorName.primaryColor,
                size: 24,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "Check M-Pesa Balance",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "To check your M-Pesa balance:",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildInstructionStep("1", "Dial *144# from your phone"),
                  SizedBox(height: 12.h),
                  _buildInstructionStep(
                      "2", "Follow the prompts to check balance"),
                  SizedBox(height: 12.h),
                  _buildInstructionStep(
                      "3", "Or check your M-Pesa SMS messages"),
                ],
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Got it",
                  style: GoogleFonts.montserrat(
                    color: ColorName.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructionStep(String number, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: ColorName.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            instruction,
            style: GoogleFonts.montserrat(
              fontSize: 13.sp,
              color: Colors.grey[600],
              height: 1.4,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
