import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:intl/intl.dart'; // Add this import at the top
import 'dart:math' as math;
import 'package:flexpromoter/features/bookings/ui/booking_data.dart';

class BookingDetailScreen extends StatelessWidget {
  final List<Booking> bookings;
  final String title;

  const BookingDetailScreen({
    super.key,
    required this.bookings,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFF337687),
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFF337687),
          elevation: 0,
          leadingWidth: 100,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(Icons.arrow_back_ios_new,
                    color: isDarkMode ? Colors.white : Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  'Back',
                  style: GoogleFonts.montserrat(
                    color: isDarkMode ? Colors.white : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ],
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(right: 40, left: 25),
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                color: isDarkMode ? Colors.white : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined,
                      color: isDarkMode ? Colors.white : Colors.white),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '0',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: bookings.length,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final progress =
                  ((booking.totalPayments ?? 0) / booking.bookingPrice * 100)
                      .clamp(0, 100);

              return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[900]
                        : ColorName.whiteColor.withOpacity(0.90),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showBookingDetails(context, booking);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Leading icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF5E0),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.storefront,
                                  color: Color(0xFFFFB300),
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Main content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.product.productName,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    booking.outlet.outletName,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Progress bar
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress / 100,
                                      backgroundColor:
                                          Colors.teal.withOpacity(0.12),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF1DB6E4),
                                      ),
                                      minHeight: 5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Reference and Amount Paid
                                  Row(
                                    children: [
                                      Text(
                                        'Ref: ',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        booking.bookingReference,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Paid: ',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'Kshs ${booking.totalPayments ?? 0}',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Trailing badge
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF5E0),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons
                                            .verified, // Replace with your asset if needed
                                        color: Color(0xFFFFB300),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${progress.toInt()}%',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'completed',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            }));
  }
}
