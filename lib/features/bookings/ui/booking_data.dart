import 'package:flexpromoter/features/bookings/cubit/bkpayment_cubit.dart';
import 'package:flexpromoter/features/bookings/repo/bookings_repo.dart';
import 'package:flexpromoter/features/bookings/ui/payment_bk.dart';
import 'package:flexpromoter/routes/app_routes.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showBookingDetails(BuildContext context, Booking booking) {
  final progress =
      ((booking.totalPayments ?? 0) / booking.bookingPrice * 100).clamp(0, 100);
  final isComplete = progress >= 100;
  final balance = (booking.bookingPrice - (booking.totalPayments ?? 0))
      .clamp(0, booking.bookingPrice);

  // Format date and time
  DateTime? createdAt;
  String formattedDate = '';
  String formattedTime = '';
  try {
    createdAt = DateTime.parse(booking.createdAt);
    formattedDate = DateFormat('dd-MM-yyyy').format(createdAt);
    formattedTime = DateFormat('HH:mm:ss').format(createdAt);
  } catch (_) {
    formattedDate = booking.createdAt;
    formattedTime = '';
  }

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final double modalHeight =
            MediaQuery.of(context).size.height * 0.45; // 65% of screen
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: modalHeight,
            maxHeight: MediaQuery.of(context).size.height * 0.95,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF184A5A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Card with details
              Container(
                margin: const EdgeInsets.only(top: 60),
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF184A5A),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: SingleChildScrollView(
                  // If you use DraggableScrollableSheet, pass scrollController here
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        booking.product?.productName ?? '',
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Outlet Name
                      Text(
                        booking.outlet?.outletName ?? '',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Colors.cyan[100],
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.1,
                        ),
                        overflow:
                            TextOverflow.visible, // or remove overflow property
                        softWrap: true,
                      ),
                      const SizedBox(height: 20),
                      // Row: Product Cost & Balance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconDetail(
                            icon: Icons.attach_money,
                            label: "Product Cost",
                            value: "Kshs ${booking.bookingPrice}",
                          ),
                          _iconDetail(
                            icon: Icons.account_balance_wallet,
                            label: "Balance",
                            value: "Kshs $balance",
                            alignEnd: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.white.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      // Row: Paid & Booking Reference
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconDetail(
                            icon: Icons.payments,
                            label: "Paid",
                            value: "Kshs ${booking.totalPayments ?? 0}",
                          ),
                          _iconDetail(
                            icon: Icons.confirmation_number,
                            label: "Reference",
                            value: booking.bookingReference,
                            alignEnd: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.white.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      // Row: Customer Phone & Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconDetail(
                            icon: Icons.phone,
                            label: "Customer Phone",
                            value: "+${booking.customerPhoneNum}",
                          ),
                          _iconDetail(
                            icon: Icons.calendar_today,
                            label: "Date",
                            value: formattedDate,
                            alignEnd: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),
                      // Row: Branch & time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconDetail(
                            icon: Icons.location_on,
                            label: "Branch",
                            value: booking.outlet?.outletName ?? '',
                          ),
                          _iconDetail(
                            icon: Icons.lock_clock,
                            label: "Time created",
                            value: formattedTime,
                            alignEnd: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (!isComplete)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: BKPaymentCubit(
                                      bookingsRepository: BookingsRepository()),
                                  child: PaymentPromptDialog(
                                    customerPhone:
                                        booking.customer?.phoneNumber1 ?? '',
                                    bookingReference: booking.bookingReference,
                                  ),
                                ),
                              );
                              if (result != null && result is Map) {
                                if (result['type'] == 'success') {
                                  CustomSnackBar.showSuccess(
                                    context,
                                    title: "Payment Prompt Sent",
                                    message: result['message'] ?? '',
                                  );
                                } else if (result['type'] == 'error') {
                                  CustomSnackBar.showError(
                                    context,
                                    title: "Payment Error",
                                    message: result['message'] ?? '',
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1DB6E4),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              textStyle: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text("Prompt Payment"),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Avatar with progress
              Positioned(
                top: 0,
                child: _BookingProgressAvatar(
                  imagePath: "assets/images/bookingicon.png",
                  progress: progress / 100,
                ),
              ),
            ],
          ),
        );
      });
}

// Helper widget for icon + detail
Widget _iconDetail({
  required IconData icon,
  required String label,
  required String value,
  bool alignEnd = false,
}) {
  return Flexible(
    child: Row(
      mainAxisAlignment:
          alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.cyan[100], size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment:
              alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: Colors.cyan[100],
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            SizedBox(
              width: 110,
              child: Text(
                value,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: alignEnd ? TextAlign.end : TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Custom avatar with progress arc
class _BookingProgressAvatar extends StatelessWidget {
  final String imagePath;
  final double progress; // 0.0 - 1.0

  const _BookingProgressAvatar({
    required this.imagePath,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _ArcPainter(progress),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  _ArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    final paint = Paint()
      ..color = const Color(0xFFFF3B30)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect.deflate(8), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
