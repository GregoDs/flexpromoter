import 'package:flexpromoter/utils/widgets/app_text.dart';
import '../../../exports.dart';
import 'dart:math' show pi, sin;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late AnimationController _continuousController;
  late List<Animation<Offset>> _slideAnimations;

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
      final begin = const Offset(-1.0, 0.0);
      final end = Offset.zero;
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
    _animationController.dispose();
    _continuousController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? Color(0xFF1A1A1A)
          : ColorName.whiteColor.withOpacity(0.90),
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
                        'assets/icon/flexlogo3.png',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Welcome message section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.medium(
                                  "Hello Promoter",
                                  color: isDarkMode
                                      ? ColorName.whiteColor.withOpacity(0.7)
                                      : ColorName.blackColor.withOpacity(0.7),
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
                            Container(
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
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Search Bar Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Icon(
                              Icons.search,
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.grey.shade400,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextField(
                              style: AppText.medium(
                                "",
                                fontSize: 16.sp,
                                color: isDarkMode
                                    ? ColorName.whiteColor
                                    : ColorName.blackColor,
                              ).style,
                              decoration: InputDecoration(
                                hintText: "Quick Validate here",
                                hintStyle: AppText.small(
                                  "",
                                  fontSize: 16.sp,
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.grey.shade400,
                                ).style,
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 16.h),
                              ),
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
                                "10",
                                ColorName.primaryColor,
                                Icons.attach_money_rounded,
                                0,
                              ),
                              SizedBox(width: 12.w),
                              _buildAnimatedStatCard(
                                "View Bookings",
                                "4",
                                Colors.black87,
                                Icons.calendar_month_rounded,
                                1,
                              ),
                              SizedBox(width: 12.w),
                              _buildAnimatedStatCard(
                                "LeaderBoard",
                                "12",
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
                        Navigator.pushNamed(context, '/make_bookings');
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            ? Colors.white.withOpacity(0.1)
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
                                            ? Colors.white.withOpacity(0.1)
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
                              right: -90.w,
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
          ],
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
              Navigator.pushNamed(context, '/view_bookings');
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
      width: 130.w,
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
              Icon(icon, color: Colors.white, size: 22.sp),
              Icon(
                Icons.touch_app_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 16.sp,
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
              SizedBox(height: 4.h),
              AppText.small(
                title,
                color: Colors.white.withOpacity(0.8),
                fontSize: 13.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
