import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flexpromoter/features/wallet/cubit/wallet_cubit.dart';
import 'package:flexpromoter/features/wallet/cubit/wallet_state.dart';
import 'package:flexpromoter/features/wallet/model/promoter_referrals_model/promoter_referrals_model.dart';
import 'package:intl/intl.dart';

class PromoterReferralsScreen extends StatefulWidget {
  const PromoterReferralsScreen({super.key});

  @override
  State<PromoterReferralsScreen> createState() =>
      _PromoterReferralsScreenState();
}

class _PromoterReferralsScreenState extends State<PromoterReferralsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Pagination variables
  int currentPage = 1;
  int totalPages = 1;
  int totalReferrals = 0;
  bool _isPaginating = false;

  // API data
  List<PromoterReferralItem> referrals = [];
  PromoterReferralsResponse? lastResponse;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadInitialData();
  }

  void _setupAnimations() {
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

  void _loadInitialData() {
    // Reset pagination
    currentPage = 1;
    referrals.clear();

    // Fetch data from API using cubit
    context.read<WalletCubit>().fetchPromoterReferrals(page: currentPage);
  }

  void _onPageChanged(int page) async {
    setState(() {
      _isPaginating = true;
      currentPage = page;
    });

    // Fetch the specific page
    await context.read<WalletCubit>().fetchPromoterReferrals(page: page);

    setState(() {
      _isPaginating = false;
    });
  }

  void _handleApiResponse(PromoterReferralsResponse response) {
    if (response.data != null) {
      final paginationData = response.data!;

      setState(() {
        // Update pagination info
        totalPages = paginationData.lastPage ?? 1;
        totalReferrals = paginationData.total ?? 0;

        // Replace data for any page (not just append)
        if (paginationData.data != null) {
          referrals = List.from(paginationData.data!);
        }

        _isPaginating = false;
        lastResponse = response;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
        GoogleFonts.montserratTextTheme(Theme.of(context).textTheme);
    final textColor = Colors.black87;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(textColor, textTheme),
      body: SafeArea(
        child: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is WalletReferralsSuccess) {
              _handleApiResponse(state.response);
            } else if (state is WalletReferralsFailure) {
              setState(() {
                _isPaginating = false;
              });

              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is WalletLoading && referrals.isEmpty) {
              return _buildLoadingState();
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildContent(textColor, textTheme),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color textColor, TextTheme textTheme) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        "My Referrals",
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh,
              color: ColorName.primaryColor, size: 24),
          onPressed: () {
            _loadInitialData();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: SpinKitThreeBounce(
        color: ColorName.primaryColor,
        size: 40,
      ),
    );
  }

  Widget _buildContent(Color textColor, TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(textColor, textTheme),
          SizedBox(height: 24.h),
          _buildStatsCard(textColor, textTheme),
          SizedBox(height: 12.h),

          // Pagination bar
          BlocBuilder<WalletCubit, WalletState>(
            builder: (context, state) {
              if (state is WalletReferralsSuccess) {
                return Center(
                  child: _isPaginating
                      ? const SpinKitCircle(
                          color: ColorName.primaryColor,
                          size: 32,
                        )
                      : _buildPaginationRow(totalPages),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          SizedBox(height: 16.h),
          _buildReferralsList(textColor, textTheme),
        ],
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
                Icons.people_alt,
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
                    "My Referrals",
                    style: GoogleFonts.montserrat(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "Track your customer registrations",
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
          "Here are all the customers you've successfully registered for FlexPay merchant wallet. Each registration earns you rewards!",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(Color textColor, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorName.primaryColor,
            ColorName.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorName.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Referrals",
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "$totalReferrals",
                  style: GoogleFonts.montserrat(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Customers Registered",
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralsList(Color textColor, TextTheme textTheme) {
    if (referrals.isEmpty) {
      return _buildEmptyState(textColor, textTheme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Referrals",
              style: GoogleFonts.montserrat(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorName.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Page $currentPage of $totalPages",
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  color: ColorName.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...referrals.asMap().entries.map((entry) {
          int index = entry.key;
          PromoterReferralItem referral = entry.value;
          return _buildReferralCard(referral, index);
        }).toList(),
      ],
    );
  }

  Widget _buildReferralCard(PromoterReferralItem referral, int index) {
    // Format the created date
    String formattedDate = "N/A";
    if (referral.createdAt != null && referral.createdAt!.isNotEmpty) {
      try {
        final DateTime date = DateTime.parse(referral.createdAt!);
        formattedDate = DateFormat('MMM dd, yyyy').format(date);
      } catch (e) {
        formattedDate = referral.createdAt!;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with customer info
              Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ColorName.primaryColor,
                          ColorName.primaryColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer #${referral.id ?? 'N/A'}",
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: ColorName.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "Active",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorName.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Customer Phone Number
              Row(
                children: [
                  Icon(
                    Icons.phone_in_talk_outlined,
                    size: 16.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Customer Phone: +${referral.customerPhone ?? 'Unknown number'}",
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Registration date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Registered on $formattedDate",
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, TextTheme textTheme) {
    return Column(
      children: [
        // Lottie Animation
        SizedBox(
          width: 160.w,
          height: 160.h,
          child: Lottie.asset(
            'assets/images/empty.json',
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Oops!",
          style: GoogleFonts.montserrat(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: ColorName.primaryColor,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          "Seems like you have not yet registered any customer",
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          "Start registering customers to earn rewards and see your referrals here",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.person_add, color: Colors.white, size: 20),
            label: Text(
              "Register Your First Customer",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorName.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              elevation: 2,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        TextButton.icon(
          onPressed: _loadInitialData,
          icon: const Icon(Icons.refresh,
              size: 18, color: ColorName.primaryColor),
          label: Text(
            "Refresh",
            style: GoogleFonts.montserrat(
              color: ColorName.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditablePageInput(int currentPage, int totalPages) {
    final controller = TextEditingController(text: currentPage.toString());
    final focusNode = FocusNode();

    return SizedBox(
      width: 48,
      height: 36,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: ColorName.primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: ColorName.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: ColorName.primaryColor),
          ),
          suffixIcon: const Icon(Icons.edit, size: 16, color: Colors.white70),
          suffixIconConstraints: const BoxConstraints(
            maxHeight: 16,
            maxWidth: 16,
          ),
        ),
        onSubmitted: (value) {
          final page = int.tryParse(value) ?? currentPage;
          if (page >= 1 && page <= totalPages && page != currentPage) {
            _onPageChanged(page.clamp(1, totalPages));
          } else {
            controller.text = currentPage.toString();
          }
        },
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
      ),
    );
  }

  Widget _buildPageButton(int page) {
    return GestureDetector(
      onTap: () {
        if (page != currentPage) _onPageChanged(page);
      },
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              page == currentPage ? ColorName.primaryColor : Colors.transparent,
          border: Border.all(
            color: ColorName.primaryColor,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '$page',
          style: GoogleFonts.montserrat(
            color: page == currentPage ? Colors.white : ColorName.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationRow(int pages) {
    if (pages <= 1) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPaginationButton("Previous", currentPage > 1, () {
            if (currentPage > 1) _onPageChanged(currentPage - 1);
          }),
          const SizedBox(width: 8),

          // First page - make editable when current
          currentPage == 1
              ? _buildEditablePageInput(1, pages)
              : _buildPageButton(1),

          if (currentPage > 4) const SizedBox(width: 8),
          if (currentPage > 4)
            Text('...',
                style: GoogleFonts.montserrat(color: ColorName.primaryColor)),

          // Show pages around current page
          if (currentPage > 2 && currentPage != pages) ...[
            const SizedBox(width: 8),
            currentPage - 1 == 1
                ? _buildPageButton(1) // Don't duplicate first page
                : _buildPageButton(currentPage - 1),
          ],
          if (currentPage > 1 && currentPage < pages) ...[
            const SizedBox(width: 8),
            _buildEditablePageInput(currentPage, pages),
          ],
          if (currentPage < pages - 1 && currentPage != 1) ...[
            const SizedBox(width: 8),
            currentPage + 1 == pages
                ? _buildPageButton(pages)
                : _buildPageButton(currentPage + 1),
          ],

          if (currentPage < pages - 3) const SizedBox(width: 8),
          if (currentPage < pages - 3)
            Text('...',
                style: GoogleFonts.montserrat(color: ColorName.primaryColor)),

          if (pages > 1) ...[
            const SizedBox(width: 8),
            currentPage == pages
                ? _buildEditablePageInput(pages, pages)
                : _buildPageButton(pages),
          ],

          const SizedBox(width: 8),
          _buildPaginationButton("Next", currentPage < pages, () {
            if (currentPage < pages) _onPageChanged(currentPage + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildPaginationButton(
      String label, bool enabled, VoidCallback onPressed) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? Colors.transparent : Colors.grey[300],
          border: Border.all(
            color: ColorName.primaryColor,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            color: enabled ? ColorName.primaryColor : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
