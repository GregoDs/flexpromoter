import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpromoter/features/bookings/cubit/bookings_state.dart';
import 'package:flexpromoter/features/bookings/ui/booking_shimmer.dart';
import 'package:flexpromoter/features/bookings/ui/booking_data.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String selectedTag = 'Active';
  int currentPage = 1;
  int totalPages = 1;
  bool _isPaginating = false;

  final List<String> tags = ['Active', 'Completed', 'Redeemed', 'Unserviced'];
  final TextEditingController _searchController = TextEditingController();
  String? _searchPhone;

  @override
  void initState() {
    super.initState();
    final bookingsCubit = context.read<BookingsCubit>();
    bookingsCubit.fetchBookingsByType(selectedTag, page: currentPage);
  }

  void _onPageChanged(int page) async {
    setState(() {
      _isPaginating = true;
      currentPage = page;
    });
    if (_searchPhone != null && _searchPhone!.isNotEmpty) {
      await context.read<BookingsCubit>().searchCustomerBookings(
            phoneNumber: _searchPhone!,
            bookingType: selectedTag,
            page: page,
          );
    } else {
      await context
          .read<BookingsCubit>()
          .fetchBookingsByType(selectedTag, page: page);
    }
    setState(() {
      _isPaginating = false;
    });
  }

  void _onSearch() {
    final phone = _searchController.text.trim();
    setState(() {
      _searchPhone = phone.isNotEmpty ? phone : null;
      currentPage = 1;
    });
    if (_searchPhone != null) {
      context.read<BookingsCubit>().searchCustomerBookings(
            phoneNumber: _searchPhone!,
            bookingType: selectedTag,
            page: 1,
          );
    } else {
      context.read<BookingsCubit>().fetchBookingsByType(selectedTag, page: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: ColorName.whiteColor,
      body: Column(
        children: [
          // Header with rounded corners
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appbarbackground.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(52),
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: size.width * 0.06,
              right: size.width * 0.06,
              bottom: size.height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Back',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "FlexPay",
                        style: GoogleFonts.montserrat(
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.04),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'View Bookings',
                    style: GoogleFonts.montserrat(
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Below are your scheduled and past bookings.',
                    style: GoogleFonts.montserrat(
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.015, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search Booking by phone number',
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.grey[500],
                        fontSize: size.width * 0.04,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch(); // Clear search
                              },
                            )
                          : null,
                    ),
                    keyboardType: TextInputType.phone,
                    onSubmitted: (_) => _onSearch(),
                    onChanged: (val) {
                      if (val.isEmpty && _searchPhone != null) {
                        _onSearch(); // Reset to normal fetch if cleared
                      }
                    },
                  ),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Tags
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              itemCount: tags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, idx) {
                final tag = tags[idx];
                final isSelected = tag == selectedTag;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTag = tag;
                      currentPage = 1;
                    });
                    if (_searchPhone != null && _searchPhone!.isNotEmpty) {
                      context.read<BookingsCubit>().searchCustomerBookings(
                            phoneNumber: _searchPhone!,
                            bookingType: tag,
                            page: 1,
                          );
                    } else {
                      context.read<BookingsCubit>().fetchBookingsByType(tag, page: 1);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF337687) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.montserrat(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
      
          //Pagination bar
          BlocBuilder<BookingsCubit, BookingsState>(
            builder: (context, state) {
              int pages = 1;
              if (state is BookingsLoaded) {
                pages = state.totalPages;
              } else if (state is CustomerBookingsSearchLoaded) {
                pages = state.totalPages;
              }
      
              return Center(
                child: _isPaginating
                    ? const SpinKitCircle(
                        color: Color(0xFF337687),
                        size: 32,
                      )
                    : _buildPaginationRow(pages),
              );
            },
          ),
      
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<BookingsCubit, BookingsState>(
              builder: (context, state) {
                if (state is BookingsLoaded) {
                  totalPages = state.totalPages;
                } else if (state is CustomerBookingsSearchLoaded) {
                  totalPages = state.totalPages;
                }
                return Builder(
                  builder: (context) {
                    if (state is BookingsLoading ||
                        state is CustomerBookingsSearchLoading) {
                      return const BookingsShimmer(isDarkMode: true);
                    } else if (state is BookingsLoaded) {
                      final bookings = state.bookings;
                      if (bookings.isEmpty) {
                        return Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              SizedBox(
                                height: 250,
                                child: Lottie.asset(
                                    'assets/images/onboarding2.json'),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'No bookings found.',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16),
                              ),
                            ]));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: bookings.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, idx) {
                          final booking = bookings[idx];
                          final isRedeemed =
                              state.bookingType.toLowerCase() ==
                                  'redeemed';
                          // Determine status color and icon
                          Color statusColor;
                          Color badgeBgColor;
                          Color badgeTextColor;
                          IconData statusIcon;
                          switch (state.bookingType) {
                            case 'Active':
                              statusColor = const Color(
                                  0xFF009BFE); // Amber
                              badgeBgColor =
                                  const Color(0xFFFFF6D6);
                              badgeTextColor =
                                  const Color(0xFFFEA900);
                              statusIcon = Icons.verified;
                              break;
                            case 'Completed':
                              statusColor =
                                  const Color(0xFF00C853);
                              badgeBgColor =
                                  const Color(0xFFD6FFD8);
                              badgeTextColor =
                                  const Color(0xFF00C853);
                              statusIcon = Icons.verified;
                              break;
                            case 'Redeemed':
                              statusColor =
                                  const Color(0xFF757575);
                              badgeBgColor =
                                  const Color(0xFFE0E0E0);
                              badgeTextColor =
                                  const Color(0xFF757575);
                              statusIcon = Icons.redeem;
                              break;
                            case 'Unserviced':
                              statusColor =
                                  const Color(0xFFD32F2F);
                              badgeBgColor =
                                  const Color(0xFFFFD6D6);
                              badgeTextColor =
                                  const Color(0xFFD32F2F);
                              statusIcon = Icons.error;
                              break;
                            default:
                              statusColor = Colors.grey;
                              badgeBgColor = Colors.grey[300]!;
                              badgeTextColor = Colors.grey[700]!;
                              statusIcon = Icons.info;
                          }
      
                          return InkWell(
                            onTap: () => showBookingDetails(
                                context, booking),
                            borderRadius:
                                BorderRadius.circular(18),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.07),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  _buildNumberBadge(idx),
                                  const SizedBox(width: 2),
                                  // Leading Icon
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 26,
                                    child: Icon(
                                      statusIcon,
                                      color: badgeTextColor,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Main Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          booking.product
                                                  ?.productName ??
                                              (isRedeemed
                                                  ? 'Redeemed Voucher'
                                                  : 'No product name'),
                                          style: GoogleFonts
                                              .montserrat(
                                            fontWeight:
                                                FontWeight.w700,
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          booking.outlet
                                                  ?.outletName ??
                                              '-',
                                          style: GoogleFonts
                                              .montserrat(
                                            fontWeight:
                                                FontWeight.w400,
                                            fontSize: 15,
                                            color:
                                                Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Progress bar
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(4),
                                          child:
                                              LinearProgressIndicator(
                                            value: ((booking.totalPayments ??
                                                        0) /
                                                    (booking.bookingPrice ==
                                                            0
                                                        ? 1
                                                        : booking
                                                            .bookingPrice))
                                                .clamp(0.0, 1.0),
                                            minHeight: 6,
                                            backgroundColor:
                                                Colors.grey[200],
                                            valueColor:
                                                AlwaysStoppedAnimation<
                                                        Color>(
                                                    statusColor),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Ref:  ${booking.bookingReference ?? '-'}',
                                                style: GoogleFonts
                                                    .montserrat(
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                  fontSize: 13,
                                                  color: Colors
                                                      .black87,
                                                ),
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 12),
                                            Flexible(
                                              child: Text(
                                                'Paid: Ksh ${booking.totalPayments}',
                                                style: GoogleFonts
                                                    .montserrat(
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                  fontSize: 13,
                                                  color: Colors
                                                      .black87,
                                                ),
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Badge and Status
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 12,
                                            vertical: 6),
                                        decoration: BoxDecoration(
                                          color: badgeBgColor,
                                          borderRadius:
                                              BorderRadius
                                                  .circular(16),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              statusIcon,
                                              color:
                                                  badgeTextColor,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                                width: 4),
                                            Text(
                                              state.bookingType ==
                                                      'Active'
                                                  ? '${(((booking.totalPayments ?? 0) / (booking.bookingPrice == 0 ? 1 : booking.bookingPrice)) * 100).clamp(0, 100).toInt()}%'
                                                  : state.bookingType ==
                                                          'Completed'
                                                      ? '100%'
                                                      : state.bookingType ==
                                                              'Redeemed'
                                                          ? 'Redeemed'
                                                          : state.bookingType ==
                                                                  'Unserviced'
                                                              ? '0%'
                                                              : '',
                                              style: GoogleFonts
                                                  .montserrat(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                fontSize: 15,
                                                color:
                                                    badgeTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        state.bookingType
                                            .toLowerCase(),
                                        style: GoogleFonts
                                            .montserrat(
                                          fontWeight:
                                              FontWeight.w400,
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state
                        is CustomerBookingsSearchLoaded) {
                      final bookings = state.bookings;
                      if (bookings.isEmpty) {
                        return Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              SizedBox(
                                height: 250,
                                child: Lottie.asset(
                                    'assets/images/onboarding2.json'),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'No bookings found.',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16),
                              ),
                            ]));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: bookings.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, idx) {
                          final booking = bookings[idx];
                          final isRedeemed =
                              state.bookingType.toLowerCase() ==
                                  'redeemed';
                          // Determine status color and icon
                          Color statusColor;
                          Color badgeBgColor;
                          Color badgeTextColor;
                          IconData statusIcon;
                          switch (state.bookingType) {
                            case 'Active':
                              statusColor = const Color(
                                  0xFF009BFE); // Amber
                              badgeBgColor =
                                  const Color(0xFFFFF6D6);
                              badgeTextColor =
                                  const Color(0xFFFEA900);
                              statusIcon = Icons.verified;
                              break;
                            case 'Completed':
                              statusColor =
                                  const Color(0xFF00C853);
                              badgeBgColor =
                                  const Color(0xFFD6FFD8);
                              badgeTextColor =
                                  const Color(0xFF00C853);
                              statusIcon = Icons.verified;
                              break;
                            case 'Redeemed':
                              statusColor =
                                  const Color(0xFF757575);
                              badgeBgColor =
                                  const Color(0xFFE0E0E0);
                              badgeTextColor =
                                  const Color(0xFF757575);
                              statusIcon = Icons.redeem;
                              break;
                            case 'Unserviced':
                              statusColor =
                                  const Color(0xFFD32F2F);
                              badgeBgColor =
                                  const Color(0xFFFFD6D6);
                              badgeTextColor =
                                  const Color(0xFFD32F2F);
                              statusIcon = Icons.error;
                              break;
                            default:
                              statusColor = Colors.grey;
                              badgeBgColor = Colors.grey[300]!;
                              badgeTextColor = Colors.grey[700]!;
                              statusIcon = Icons.info;
                          }
      
                          return InkWell(
                            onTap: () => showBookingDetails(
                                context, booking),
                            borderRadius:
                                BorderRadius.circular(18),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.07),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  _buildNumberBadge(idx),
                                  const SizedBox(width: 2),
                                  // Leading Icon
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 26,
                                    child: Icon(
                                      statusIcon,
                                      color: badgeTextColor,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Main Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          booking.product
                                                  ?.productName ??
                                              (isRedeemed
                                                  ? 'Redeemed Voucher'
                                                  : 'No product name'),
                                          style: GoogleFonts
                                              .montserrat(
                                            fontWeight:
                                                FontWeight.w700,
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          booking.outlet
                                                  ?.outletName ??
                                              '-',
                                          style: GoogleFonts
                                              .montserrat(
                                            fontWeight:
                                                FontWeight.w400,
                                            fontSize: 15,
                                            color:
                                                Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Progress bar
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(4),
                                          child:
                                              LinearProgressIndicator(
                                            value: ((booking.totalPayments ??
                                                        0) /
                                                    (booking.bookingPrice ==
                                                            0
                                                        ? 1
                                                        : booking
                                                            .bookingPrice))
                                                .clamp(0.0, 1.0),
                                            minHeight: 6,
                                            backgroundColor:
                                                Colors.grey[200],
                                            valueColor:
                                                AlwaysStoppedAnimation<
                                                        Color>(
                                                    statusColor),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Ref:  ${booking.bookingReference ?? '-'}',
                                                style: GoogleFonts
                                                    .montserrat(
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                  fontSize: 13,
                                                  color: Colors
                                                      .black87,
                                                ),
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 12),
                                            Flexible(
                                              child: Text(
                                                'Paid: Ksh ${booking.totalPayments}',
                                                style: GoogleFonts
                                                    .montserrat(
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                  fontSize: 13,
                                                  color: Colors
                                                      .black87,
                                                ),
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Badge and Status
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 12,
                                            vertical: 6),
                                        decoration: BoxDecoration(
                                          color: badgeBgColor,
                                          borderRadius:
                                              BorderRadius
                                                  .circular(16),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              statusIcon,
                                              color:
                                                  badgeTextColor,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                                width: 4),
                                            Text(
                                              state.bookingType ==
                                                      'Active'
                                                  ? '${(((booking.totalPayments ?? 0) / (booking.bookingPrice == 0 ? 1 : booking.bookingPrice)) * 100).clamp(0, 100).toInt()}%'
                                                  : state.bookingType ==
                                                          'Completed'
                                                      ? '100%'
                                                      : state.bookingType ==
                                                              'Redeemed'
                                                          ? 'Redeemed'
                                                          : state.bookingType ==
                                                                  'Unserviced'
                                                              ? '0%'
                                                              : '',
                                              style: GoogleFonts
                                                  .montserrat(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                fontSize: 15,
                                                color:
                                                    badgeTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        state.bookingType
                                            .toLowerCase(),
                                        style: GoogleFonts
                                            .montserrat(
                                          fontWeight:
                                              FontWeight.w400,
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is BookingsError ||
                        state is CustomerBookingsSearchError) {
                      final msg = state is BookingsError
                          ? state.message
                          : (state as CustomerBookingsSearchError)
                              .message;
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 180,
                              child: Lottie.asset(
                                  'assets/images/onboarding2.json'),
                            ),
                            Text(
                              'Failed to load Bookings.Please check your internet connection and try again ',
                              style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberBadge(int index) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF337687),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        '#${index + 1}',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
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
          fillColor: const Color(0xFF337687),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF337687)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF337687)),
          ),
          // Add cursor indicator
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
            // Reset to current page if invalid
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
          color: page == currentPage
              ? const Color(0xFF337687)
              : Colors.transparent,
          border: Border.all(
            color: const Color(0xFF337687),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '$page',
          style: GoogleFonts.montserrat(
            color: page == currentPage ? Colors.white : const Color(0xFF337687),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationRow(int pages) {
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
                style: GoogleFonts.montserrat(color: const Color(0xFF337687))),

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
                style: GoogleFonts.montserrat(color: const Color(0xFF337687))),

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
            color: const Color(0xFF337687),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            color: enabled ? const Color(0xFF337687) : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
