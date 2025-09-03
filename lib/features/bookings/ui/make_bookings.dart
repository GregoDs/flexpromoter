import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flexpromoter/features/bookings/cubit/make_booking_cubit.dart';
import 'package:flexpromoter/features/bookings/models/make_bookings_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MakeBookingsScreen extends StatefulWidget {
  const MakeBookingsScreen({super.key});

  @override
  State<MakeBookingsScreen> createState() => _MakeBookingsScreenState();
}

class _MakeBookingsScreenState extends State<MakeBookingsScreen>
    with TickerProviderStateMixin {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController bookingPriceController = TextEditingController();
  final TextEditingController bookingDaysController = TextEditingController();
  final TextEditingController initialDepositController =
      TextEditingController();
  final TextEditingController productNameController = TextEditingController();

  late AnimationController _animationController;
  late AnimationController _formAnimController;
  late Animation<double> _formAnim;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _formAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _formAnim = CurvedAnimation(
      parent: _formAnimController,
      curve: Curves.easeOutBack,
    );
    _formAnimController.forward();
  }

  void _clearFields() {
    phoneNumberController.clear();
    firstNameController.clear();
    lastNameController.clear();
    bookingPriceController.clear();
    bookingDaysController.clear();
    initialDepositController.clear();
    productNameController.clear();
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor =
        isDarkMode ? const Color(0xFF10151A) : const Color(0xFFF5F8FA);
    final cardColor = isDarkMode ? const Color(0xFF1A222C) : Colors.white;
    final fieldBackgroundColor =
        isDarkMode ? Colors.grey[850] : Colors.grey[100];
    final borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(Icons.arrow_back_ios_new, color: textColor, size: 16),
              const SizedBox(width: 4),
              Text(
                'Back',
                style: GoogleFonts.montserrat(
                  color: textColor,
                  fontSize: 14,
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
            'Make Booking',
            style: GoogleFonts.montserrat(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: textColor),
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
      body: Stack(
        children: [
          FadeTransition(
            opacity: _formAnim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(_formAnim),
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 26),
                  child: Card(
                    color: cardColor,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 28),
                      child: BlocConsumer<MakeBookingCubit, MakeBookingState>(
                        listener: (context, state) {
                          if (state is MakeBookingSuccess) {
                            _clearFields();
                            _showSuccessAnimation();
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.blueGrey[800]
                                          : Colors.blue[50],
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(18),
                                    child: Icon(Icons.event_note_rounded,
                                        color: Colors.blue[700], size: 38),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Book a Product",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Fill in the details below to create a booking.",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: hintColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Form fields
                              _buildInputField(
                                label: 'First Name',
                                controller: firstNameController,
                                icon: Icons.person_outline,
                                textColor: textColor,
                                hintColor: hintColor ?? Colors.grey,
                                fieldBackgroundColor:
                                    fieldBackgroundColor ?? Colors.grey,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Last Name',
                                controller: lastNameController,
                                icon: Icons.person_outline,
                                textColor: textColor,
                                hintColor: hintColor ?? Colors.grey,
                                fieldBackgroundColor:
                                    fieldBackgroundColor ?? Colors.grey,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Phone Number',
                                controller: phoneNumberController,
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                textColor: textColor,
                                hintColor: hintColor ?? Colors.grey,
                                fieldBackgroundColor:
                                    fieldBackgroundColor ?? Colors.grey,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Product Name',
                                controller: productNameController,
                                icon: Icons.shopping_bag_outlined,
                                textColor: textColor,
                                hintColor: hintColor ?? Colors.grey,
                                fieldBackgroundColor:
                                    fieldBackgroundColor ?? Colors.grey,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Booking Price',
                                controller: bookingPriceController,
                                icon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                                textColor: textColor,
                                hintColor: hintColor ?? Colors.grey,
                                fieldBackgroundColor:
                                    fieldBackgroundColor ?? Colors.grey,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Booking Days',
                                controller: bookingDaysController,
                                icon: Icons.calendar_today_outlined,
                                keyboardType: TextInputType.number,
                                textColor: textColor,
                                hintColor: hintColor ?? Colors.grey,
                                fieldBackgroundColor:
                                    fieldBackgroundColor ?? Colors.grey,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Initial Deposit',
                                controller: initialDepositController,
                                icon: Icons.account_balance_wallet_outlined,
                                keyboardType: TextInputType.number,
                                textColor: textColor,
                                hintColor: hintColor ?? Colors.grey,
                                fieldBackgroundColor:
                                    fieldBackgroundColor ?? Colors.grey,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 28),
                              if (state is MakeBookingLoading)
                                const SpinKitThreeBounce(
                                  color: Colors.blue,
                                  size: 28,
                                )
                              else
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Basic validation: prevent empty fields
                                      if (firstNameController.text.isEmpty ||
                                          lastNameController.text.isEmpty ||
                                          phoneNumberController.text.isEmpty ||
                                          productNameController.text.isEmpty ||
                                          bookingPriceController.text.isEmpty ||
                                          bookingDaysController.text.isEmpty ||
                                          initialDepositController
                                              .text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please fill in all fields.',
                                              style: GoogleFonts.montserrat(),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      final bookingRequest =
                                          BookingRequestModel(
                                        phoneNumber: phoneNumberController.text,
                                        userId: "1", // TODO: Get actual user ID
                                        bookingPrice:
                                            bookingPriceController.text,
                                        bookingDays: bookingDaysController.text,
                                        initialDeposit:
                                            initialDepositController.text,
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        productName: productNameController.text,
                                      );
                                      context
                                          .read<MakeBookingCubit>()
                                          .createBooking(
                                            context,
                                            bookingRequest,
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[700],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.blue[200],
                                    ),
                                    child: Text(
                                      'Create Booking',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_showAnimation)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Lottie.asset(
                    'assets/images/success.json',
                    controller: _animationController,
                    fit: BoxFit.contain,
                    onLoaded: (composition) {
                      // Ensure animation controller duration matches Lottie
                      _animationController.duration = composition.duration;
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color textColor,
    required Color hintColor,
    required Color fieldBackgroundColor,
    required Color borderColor,
    TextInputType? keyboardType,
  }) {
    // Use decimal keyboard for price/deposit fields
    TextInputType? effectiveKeyboardType = keyboardType;
    if (label == 'Booking Price' || label == 'Initial Deposit') {
      effectiveKeyboardType =
          const TextInputType.numberWithOptions(decimal: true);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: effectiveKeyboardType,
          style: GoogleFonts.montserrat(
            color: textColor,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: hintColor, size: 20),
            // Fix hint text to only lowercase the first letter after "Enter"
            hintText: 'Enter ${label[0].toLowerCase()}${label.substring(1)}',
            hintStyle: GoogleFonts.montserrat(
              color: hintColor,
              fontSize: 14,
            ),
            filled: true,
            fillColor: fieldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[400]!),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _formAnimController.dispose();
    phoneNumberController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    bookingPriceController.dispose();
    bookingDaysController.dispose();
    initialDepositController.dispose();
    productNameController.dispose();
    super.dispose();
  }
}
