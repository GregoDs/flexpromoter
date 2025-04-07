import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpromoter/features/bookings/cubit/bookings_state.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/features/bookings/ui/booking_details.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    // Provide context to cubit and fetch bookings
    final bookingsCubit = context.read<BookingsCubit>();
    bookingsCubit.setContext(context);
    bookingsCubit.fetchAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFF337687),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.12),
        child: AppBar(
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFF337687),
          elevation: 0,
          leading: Container(
            padding: const EdgeInsets.only(left: 8),
            width: 80,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Back',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "FlexPay",
            style: GoogleFonts.montserrat(
              fontSize: size.width * 0.08,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View Bookings',
                  style: GoogleFonts.montserrat(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Below are your scheduled and past bookings.',
                  style: GoogleFonts.montserrat(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<BookingsCubit, BookingsState>(
              builder: (context, state) {
                if (state is BookingsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  );
                }

                if (state is BookingsLoaded) {
                  return _buildBookingCards(isDarkMode, {
                    'Active Bookings': {
                      'data': state.openBookings,
                      'count': state.openBookings.length,
                    },
                    'Completed Bookings': {
                      'data': state.closedBookings,
                      'count': state.closedBookings.length,
                    },
                    'Redeemed Bookings': {
                      'data': state.redeemedBookings,
                      'count': state.redeemedBookings.length,
                    },
                    'Unserviced Bookings': {
                      'data': state.unservicedBookings,
                      'count': state.unservicedBookings.length,
                    },
                  });
                }

                return _buildBookingCards(isDarkMode, {
                  'Open Bookings': {'data': <Booking>[], 'count': '-'},
                  'Closed Bookings': {'data': <Booking>[], 'count': '-'},
                  'Redeemed Bookings': {'data': <Booking>[], 'count': '-'},
                  'Unserviced Bookings': {'data': <Booking>[], 'count': '-'},
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCards(
      bool isDarkMode, Map<String, Map<String, dynamic>> bookingsData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: bookingsData.entries.map((entry) {
          final bookings = entry.value['data'] as List<Booking>;
          final bool isClickable = bookings.isNotEmpty;

          return GestureDetector(
            onTap: isClickable
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailScreen(
                          bookings: bookings,
                          title: entry.key,
                        ),
                      ),
                    );
                  }
                : null,
            child: _buildStyledCard(
              entry.key,
              entry.value['count'].toString(),
              isClickable ? "Tap to view details" : "No bookings available",
              isDarkMode,
              isClickable: isClickable,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStyledCard(
      String title, String value, String message, bool isDarkMode,
      {bool isClickable = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDarkMode
            ? (isClickable ? Colors.grey[900] : Colors.grey[800])
            : ColorName.whiteColor.withOpacity(isClickable ? 0.90 : 0.70),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
