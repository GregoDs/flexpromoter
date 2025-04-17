import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';

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
                  Icon(Icons.arrow_back_ios_new, color: isDarkMode ? Colors.white : Colors.white, size: 20),
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
                    icon: Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.white : Colors.white),
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
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final progress =
              ((booking.totalPayments ?? 0) / booking.bookingPrice * 100)
                  .clamp(0, 100);

          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : ColorName.whiteColor.withOpacity(0.90),
              borderRadius: BorderRadius.circular(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              booking.product.productName,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: isDarkMode ? Colors.white54 : Colors.black54,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reference: ${booking.bookingReference}',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Progress: ',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${progress.toInt()}%',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: isDarkMode ? const Color(0xFF4CD964) : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF4CD964)),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Amount Paid: Kshs ${booking.totalPayments ?? 0}',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showBookingDetails(BuildContext context, Booking booking) {
    final progress = ((booking.totalPayments ?? 0) / booking.bookingPrice * 100)
        .clamp(0, 100);
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : const Color(0xFF337687),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Details',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Product Name', booking.product.productName),
              _buildDetailRow('Booking Reference', booking.bookingReference),
              _buildDetailRow('Booking Price', 'Kshs ${booking.bookingPrice}'),
              _buildDetailRow(
                  'Amount Paid', 'Kshs ${booking.totalPayments ?? 0}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Progress: ',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    '${progress.toInt()}%',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: const Color(0xFF4CD964),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF4CD964)),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Customer Phone', booking.customer.phoneNumber1),
              _buildDetailRow('Branch', booking.outlet.outletName),
              _buildDetailRow('Date', booking.createdAt),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
