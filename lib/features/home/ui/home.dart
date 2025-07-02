import 'package:flexpromoter/features/home/cubit/validate_receipt_state.dart';
import 'package:flexpromoter/utils/cache/shared_preferences_helper.dart';
import 'package:flexpromoter/utils/widgets/app_text.dart';
import '../../../exports.dart';
import 'dart:math' show pi, sin;
import 'sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/validate_receipt_cubit.dart';
import '../models/validate_model.dart';
import '../repo/home_repo.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _receiptController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _continuousController;
  late List<Animation<Offset>> _slideAnimations;
  bool _showSuccessAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _continuousController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Create animations for each card with different delays
    _slideAnimations = List.generate(3, (index) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      final curve = CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2, // Stagger the start time
          1.0,
          curve: Curves.easeOutCubic,
        ),
      );
      return Tween<Offset>(begin: begin, end: end).animate(curve);
    });

    // Start the animation after a brief delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _receiptController.dispose();
    _animationController.dispose();
    _continuousController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showSuccessFeedback() {
    setState(() {
      _showSuccessAnimation = true;
    });

    // Hide the animation after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSuccessAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => ValidateReceiptCubit(HomeRepo(), context),
      child: BlocListener<ValidateReceiptCubit, ValidateReceiptState>(
        listener: (context, state) {
          if (state is ValidateReceiptSuccess) {
            _showSuccessFeedback();
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: isDarkMode
                  ? const Color(0xFF1A1A1A)
                  : ColorName.whiteColor.withOpacity(0.90),
              endDrawer: const SideMenu(),
              body: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),
                          // Flexpay Logo
                          Center(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? ColorName.primaryColor
                                    : ColorName.primaryColor,
                                BlendMode.srcIn,
                              ),
                              child: Image.asset(
                                'assets/icon/flexhomelogo.png',
                                height: 60.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Live Virtual Try-on Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Welcome message section
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText.medium(
                                          "Hello Promoter",
                                          color: isDarkMode
                                              ? ColorName.whiteColor
                                                  .withOpacity(0.7)
                                              : ColorName.blackColor
                                                  .withOpacity(0.7),
                                          fontSize: 14.sp,
                                        ),
                                        SizedBox(height: 4.h),
                                        AppText.medium(
                                          "Welcome back",
                                          color: isDarkMode
                                              ? ColorName.whiteColor
                                              : ColorName.blackColor,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                    // Profile Status Avatar
                                    Builder(
                                      builder: (context) => GestureDetector(
                                        onTap: () {
                                          Scaffold.of(context).openEndDrawer();
                                        },
                                        child: Container(
                                          width: 42.w,
                                          height: 42.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDarkMode
                                                  ? ColorName.whiteColor
                                                  : ColorName.primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: isDarkMode
                                                ? Colors.white.withOpacity(0.1)
                                                : Colors.grey.shade100,
                                            child: Icon(
                                              Icons.person,
                                              color: isDarkMode
                                                  ? ColorName.whiteColor
                                                  : ColorName.primaryColor,
                                              size: 24.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Search Bar Section - Enhanced
Padding(
  padding: EdgeInsets.symmetric(horizontal: 20.w),
  child: AnimatedContainer(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    height: 60.h,
    decoration: BoxDecoration(
      gradient: isDarkMode
          ? LinearGradient(
              colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.04)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : LinearGradient(
              colors: [ColorName.primaryColor.withOpacity(0.08), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(
        color: isDarkMode ? Colors.white.withOpacity(0.1) : ColorName.primaryColor.withOpacity(0.4),
        width: 1.2,
      ),
      boxShadow: [
        if (!isDarkMode)
          BoxShadow(
            color: ColorName.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
          
      ],
    ),
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Icon(
            Icons.receipt_long_rounded,
            color: isDarkMode
                ? Colors.white.withOpacity(0.7)
                : ColorName.primaryColor,
            size: 26.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: BlocBuilder<ValidateReceiptCubit, ValidateReceiptState>(
            builder: (context, state) {
              return TextField(
                controller: _receiptController,
                style: AppText.medium(
                  "",
                  fontSize: 16.sp,
                  color: isDarkMode
                      ? ColorName.whiteColor
                      : ColorName.blackColor,
                ).style,
                decoration: InputDecoration(
                  hintText: "Validate Receipt number here",
                  hintStyle: AppText.small(
                    "",
                    fontSize: 15.sp,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.4)
                        : ColorName.primaryColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ).style,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                  suffixIcon: state is ValidateReceiptLoading
                      ? Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDarkMode
                                    ? Colors.white
                                    : ColorName.primaryColor,
                              ),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () async {
                            if (_receiptController.text.isNotEmpty) {
                              final bookingReference =
                                  await SharedPreferencesHelper
                                      .getBookingReference();
                              final bookingPrice =
                                  await SharedPreferencesHelper
                                      .getBookingPrice();

                              context.read<ValidateReceiptCubit>().validateReceipt(
                                    ValidateReceiptModel(
                                      slipNo: _receiptController.text,
                                      bookingReference: bookingReference ?? '',
                                      bookingPrice: bookingPrice ?? '',
                                    ),
                                  );
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: isDarkMode
                                ? Colors.white
                                : ColorName.primaryColor,
                            size: 24.sp,
                          ),
                        ),
                ),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    final bookingReference =
                        await SharedPreferencesHelper.getBookingReference();
                    final bookingPrice =
                        await SharedPreferencesHelper.getBookingPrice();

                    context.read<ValidateReceiptCubit>().validateReceipt(
                          ValidateReceiptModel(
                            slipNo: value,
                            bookingReference: bookingReference ?? '',
                            bookingPrice: bookingPrice ?? '',
                          ),
                        );

                    _receiptController.clear();
                  }
                },
              );
            },
          ),
        ),
      ],
    ),
  ),
),

                          SizedBox(height: 24.h),

                          // Stats Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.small(
                                  "Your stats",
                                  fontSize: 20.sp,
                                  color: isDarkMode
                                      ? ColorName.whiteColor
                                      : ColorName.blackColor,
                                ),
                                SizedBox(height: 8.h),
                                SizedBox(
                                  height: 160.h,
                                  child: ListView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      _buildAnimatedStatCard(
                                        "Commissions",
                                        "",
                                        ColorName.primaryColor,
                                        Icons.attach_money_rounded,
                                        0,
                                      ),
                                      SizedBox(width: 12.w),
                                      _buildAnimatedStatCard(
                                        "View Bookings",
                                        "",
                                        Colors.black87,
                                        Icons.calendar_month_rounded,
                                        1,
                                      ),
                                      SizedBox(width: 12.w),
                                      _buildAnimatedStatCard(
                                        "LeaderBoard",
                                        "",
                                        Colors.amber,
                                        Icons.leaderboard_rounded,
                                        2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Make Bookings Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/make-bookings');
                              },
                              child: Container(
                                height: 180.h,
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Content
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText.small(
                                              "Make your\nBookings",
                                              fontSize: 26.sp,
                                              color: isDarkMode
                                                  ? ColorName.whiteColor
                                                  : ColorName.blackColor,
                                            ),
                                            Icon(
                                              Icons.touch_app_rounded,
                                              color: isDarkMode
                                                  ? ColorName.whiteColor
                                                      .withOpacity(0.7)
                                                  : ColorName.blackColor
                                                      .withOpacity(0.7),
                                              size: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 8.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? Colors.white
                                                        .withOpacity(0.1)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.touch_app_rounded,
                                                    size: 16.sp,
                                                    color: isDarkMode
                                                        ? ColorName.whiteColor
                                                        : ColorName.blackColor,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  AppText.medium(
                                                    "Tap to view",
                                                    fontSize: 14.sp,
                                                    color: isDarkMode
                                                        ? ColorName.whiteColor
                                                        : ColorName.blackColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Container(
                                              padding: EdgeInsets.all(8.w),
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? Colors.white
                                                        .withOpacity(0.1)
                                                    : Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.touch_app_rounded,
                                                size: 16.sp,
                                                color: isDarkMode
                                                    ? ColorName.whiteColor
                                                    : ColorName.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Image Overlay
                                    Positioned(
                                      right: -130.w,
                                      top: -60.h,
                                      child: Image.asset(
                                        'assets/images/Background.png',
                                        fit: BoxFit.cover,
                                        height: 220.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                    if (_showSuccessAnimation)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Lottie.asset(
                            'assets/images/success.json',
                            width: 200.w,
                            height: 200.h,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStoryAvatar(bool isUser, [String? username]) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isUser ? Colors.grey.shade300 : ColorName.primaryColor,
                width: 2,
              ),
            ),
            child: Center(
              child: isUser
                  ? Icon(Icons.add, size: 24.sp)
                  : CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.person, color: Colors.grey.shade400),
                    ),
            ),
          ),
          SizedBox(height: 4.h),
          AppText.small(
            isUser ? "You" : username ?? "",
            fontSize: 12.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatCard(
      String title, String value, Color color, IconData icon, int index) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: AnimatedBuilder(
        animation: _continuousController,
        builder: (context, child) {
          final phaseShift = index * (pi / 3);
          final yOffset =
              2 * sin(_continuousController.value * 2 * pi + phaseShift);
          final scale = 1.0 +
              0.02 * sin(_continuousController.value * 2 * pi + phaseShift);

          return Transform(
            transform: Matrix4.identity()
              ..translate(0.0, yOffset)
              ..scale(scale),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: () {
            if (title == "Commissions") {
              Navigator.pushNamed(context, '/commissions');
            } else if (title == "View Bookings") {
              Navigator.pushNamed(context, '/bookings');
            } else if (title == "LeaderBoard") {
              Navigator.pushNamed(context, '/leaderboard');
            }
          },
          child: _buildStatCard(title, value, color, icon),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      width: 125.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 30.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(38.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            offset: const Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: color.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 34.sp),
              Icon(
                Icons.touch_app_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 26.sp,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.large(
                value,
                color: Colors.white,
                fontSize: 26.sp,
              ),
              SizedBox(height: 2.h),
              AppText.small(
                title,
                color: Colors.white.withOpacity(0.8),
                fontSize: 11.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
