import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/bookings/cubit/bkpayment_cubit.dart';
import 'package:flexpromoter/features/bookings/repo/bookings_repo.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';

class BookingPaymentPage extends StatefulWidget {
  final String customerPhone;
  final String bookingReference;

  const BookingPaymentPage({
    Key? key,
    required this.customerPhone,
    required this.bookingReference,
  }) : super(key: key);

  @override
  State<BookingPaymentPage> createState() => _BookingPaymentPageState();
}

class _BookingPaymentPageState extends State<BookingPaymentPage> {
  late TextEditingController _phoneController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.customerPhone);
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color cardColor = isDarkMode ? Colors.grey[850]! : Colors.grey[200]!;
    Color buttonColor = isDarkMode ? Colors.blue[400]! : Colors.blue[700]!;
    final borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final accentColor = const Color(0xFF1DB6E4);

    return BlocProvider(
      create: (_) => BKPaymentCubit(bookingsRepository: BookingsRepository()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Make Payment",
            style: GoogleFonts.montserrat(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Icon(Icons.star,
                        color: Colors.amber, size: screenWidth * 0.05),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Prompt the customer to make payment of the booking created",
                        style: GoogleFonts.montserrat(
                          fontSize: screenWidth * 0.04,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Divider(
                    color: Colors.blue,
                    thickness: 2,
                    endIndent: screenWidth * 0.75),
                SizedBox(height: screenHeight * 0.03),

                // **Select Top Up Method**
                Text(
                  "Selected Payment Method",
                  style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // **M-Pesa Box**
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth * 0.2,
                        height: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                          color: isDarkMode
                              ? Colors.grey[800]
                              : Colors.transparent,
                        ),
                        child: Icon(Icons.phone_android,
                            color: Colors.blue, size: screenWidth * 0.1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "M-Pesa",
                        style: GoogleFonts.montserrat(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Phone Number Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _phoneController,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.phone, color: accentColor, size: 22),
                      hintText: "Enter Phone Number",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.montserrat(
                        color: textColor.withOpacity(0.5),
                        fontSize: 15,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 24),

                // **Enter Amount Field**
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter Amount (KES)",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _amountController,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money,
                          color: accentColor, size: 22),
                      hintText: "Enter Amount (KES)",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.montserrat(
                        color: textColor.withOpacity(0.5),
                        fontSize: 15,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 36),

                // Make Payment Button
                BlocConsumer<BKPaymentCubit, BKPaymentState>(
                  listener: (context, state) {
                    if (state is BKPaymentSuccess) {
                      CustomSnackBar.showSuccess(
                        context,
                        title: "Payment Prompt Sent",
                        message: state.message,
                      );
                      // Navigator.pop(context); 
                    } else if (state is BKPaymentError) {
                      CustomSnackBar.showError(
                        context,
                        title: "Payment Error",
                        message: state.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is BKPaymentLoading
                            ? null
                            : () {
                                final request = PromptBookingPaymentRequest(
                                  reference: widget.bookingReference,
                                  phone: _phoneController.text.trim(),
                                  amount: _amountController.text.trim(),
                                );
                                context
                                    .read<BKPaymentCubit>()
                                    .promptPayment(request);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: state is BKPaymentLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Make Payment",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.1,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
