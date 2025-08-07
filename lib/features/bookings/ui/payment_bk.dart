import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flexpromoter/features/bookings/cubit/bkpayment_cubit.dart';
import 'package:flexpromoter/features/bookings/models/bookings_model.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';

class PaymentPromptDialog extends StatefulWidget {
  final String customerPhone;
  final String bookingReference;

  const PaymentPromptDialog({
    Key? key,
    required this.customerPhone,
    required this.bookingReference,
  }) : super(key: key);

  @override
  State<PaymentPromptDialog> createState() => _PaymentPromptDialogState();
}

class _PaymentPromptDialogState extends State<PaymentPromptDialog>
    with SingleTickerProviderStateMixin {
  late TextEditingController _phoneController;
  late TextEditingController _amountController;
  late AnimationController _animationController;
  bool _showAnimation = true;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.customerPhone);
    _amountController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showSuccessAnimation() {
    setState(() {
      _showAnimation = true;
    });
    _animationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showAnimation = false;
          });
          _animationController.reset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF184A5A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: BlocConsumer<BKPaymentCubit, BKPaymentState>(
          listener: (context, state) {
            if (state is BKPaymentSuccess) {
              _showSuccessAnimation();
              Future.delayed(const Duration(milliseconds: 800), () {
                if (context.mounted) {
                  Navigator.of(context).pop({
                    'type': 'success',
                    'message': 'Payment prompt sent successfully',
                  });
                }
              });
            } else if (state is BKPaymentError) {
              // Show error message in the dialog, do NOT pop the dialog
              CustomSnackBar.showError(
                context,
                title: "Payment Error",
                message: state.error,
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "Prompt Payment",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _phoneController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: GoogleFonts.montserrat(color: Colors.cyan[100]),
                    prefixIcon: Icon(Icons.phone, color: Colors.cyan[100]),
                    filled: true,
                    fillColor: const Color(0xFF20687A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Amount (KES)",
                    labelStyle: GoogleFonts.montserrat(color: Colors.cyan[100]),
                    prefixIcon:
                        Icon(Icons.attach_money, color: Colors.cyan[100]),
                    filled: true,
                    fillColor: const Color(0xFF20687A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    child: state is BKPaymentLoading
                        ? const SpinKitWave(
                            color: Colors.white,
                            size: 32,
                          )
                        : const Text("Send Prompt"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget buildToast(String message, Color backgroundColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: backgroundColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, color: Colors.white),
        const SizedBox(width: 12.0),
        Text(
          message,
          style: GoogleFonts.montserrat(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
