import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flexpromoter/features/bookings/cubit/make_booking_cubit.dart';
import 'package:flexpromoter/features/bookings/models/make_bookings_model.dart';

class MakeBookingsScreen extends StatefulWidget {
  const MakeBookingsScreen({super.key});

  @override
  State<MakeBookingsScreen> createState() => _MakeBookingsScreenState();
}

class _MakeBookingsScreenState extends State<MakeBookingsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController bookingPriceController = TextEditingController();
  final TextEditingController bookingDaysController = TextEditingController();
  final TextEditingController initialDepositController =
      TextEditingController();
  final TextEditingController productNameController = TextEditingController();

  late AnimationController _animationController;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
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
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final fieldBackgroundColor = isDarkMode ? Colors.grey[800] : Colors.white;
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
          BlocConsumer<MakeBookingCubit, MakeBookingState>(
            listener: (context, state) {
              if (state is MakeBookingSuccess) {
                _clearFields();
                _showSuccessAnimation();
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Name',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: firstNameController,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter first name',
                        hintStyle: GoogleFonts.montserrat(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: fieldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Last Name',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: lastNameController,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter last name',
                        hintStyle: GoogleFonts.montserrat(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: fieldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Phone Number',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        hintStyle: GoogleFonts.montserrat(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: fieldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Product Name',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: productNameController,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter product name',
                        hintStyle: GoogleFonts.montserrat(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: fieldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Booking Price',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: bookingPriceController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter booking price',
                        hintStyle: GoogleFonts.montserrat(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: fieldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Booking Days',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: bookingDaysController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter number of days',
                        hintStyle: GoogleFonts.montserrat(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: fieldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Initial Deposit',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: initialDepositController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter initial deposit',
                        hintStyle: GoogleFonts.montserrat(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: fieldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state is MakeBookingLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final bookingRequest = BookingRequestModel(
                              phoneNumber: phoneNumberController.text,
                              userId: "1", // TODO: Get actual user ID
                              bookingPrice: bookingPriceController.text,
                              bookingDays: bookingDaysController.text,
                              initialDeposit: initialDepositController.text,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              productName: productNameController.text,
                            );

                            context.read<MakeBookingCubit>().createBooking(
                                  context,
                                  bookingRequest,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDarkMode ? Colors.blue[800] : Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Create Booking',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (_showAnimation)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Lottie.asset(
                    'assets/images/success.json', // You'll need to add this animation file
                    controller: _animationController,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
