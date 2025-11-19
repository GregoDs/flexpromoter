import 'package:flexpromoter/features/bookings/cubit/make_booking_cubit.dart';
import 'package:flexpromoter/features/bookings/models/make_bookings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flexpromoter/routes/app_routes.dart';
import 'package:flexpromoter/utils/getters/getters.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';

// Placeholder for Booking Cubit and State (to be linked later)
class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());
}

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingError extends BookingState {
  final String errorMessage;
  BookingError(this.errorMessage);
}

class MakeBookingsScreen extends StatefulWidget {
  const MakeBookingsScreen({super.key});

  @override
  State<MakeBookingsScreen> createState() => _MakeBookingsScreenState();
}

class _MakeBookingsScreenState extends State<MakeBookingsScreen> {
  bool _showValidationErrors = false;

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController bookingPriceController = TextEditingController();
  final TextEditingController initialDepositController =
      TextEditingController();
  final TextEditingController bookingDaysController = TextEditingController();

  // Validation state
  String? firstNameError;
  String? lastNameError;
  String? phoneError;
  String? productNameError;
  String? bookingPriceError;
  String? initialDepositError;
  String? bookingDaysError;

  void _validateFields() {
    setState(() {
      firstNameError = firstNameController.text.trim().isEmpty
          ? "First name is required"
          : null;

      lastNameError = lastNameController.text.trim().isEmpty
          ? "Last name is required"
          : null;

      phoneError = phoneController.text.trim().isEmpty
          ? "Phone number is required"
          : (!RegExp(r'^\d{10,13}$').hasMatch(phoneController.text.trim())
              ? "Enter a valid phone number"
              : null);

      productNameError = productNameController.text.trim().isEmpty
          ? "Product name is required"
          : null;

      bookingPriceError = bookingPriceController.text.trim().isEmpty
          ? "Booking price is required"
          : (!RegExp(r'^\d+(\.\d{1,2})?$')
                  .hasMatch(bookingPriceController.text.trim())
              ? "Enter a valid price (e.g., 100.00)"
              : null);

      initialDepositError = initialDepositController.text.trim().isEmpty
          ? "Initial deposit is required"
          : (!RegExp(r'^\d+(\.\d{1,2})?$')
                  .hasMatch(initialDepositController.text.trim())
              ? "Enter a valid deposit (e.g., 50.00)"
              : null);

      bookingDaysError = bookingDaysController.text.trim().isEmpty
          ? "Booking days are required"
          : (!RegExp(r'^\d+$').hasMatch(bookingDaysController.text.trim())
              ? "Enter a valid number of days"
              : null);
    });
  }

  void _submit() {
    setState(() {
      _showValidationErrors = true;
    });
    _validateFields();

    if (firstNameError == null &&
        lastNameError == null &&
        phoneError == null &&
        productNameError == null &&
        bookingPriceError == null &&
        initialDepositError == null &&
        bookingDaysError == null) {
      final bookingRequest = BookingRequestModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        productName: productNameController.text.trim(),
        bookingPrice: bookingPriceController.text.trim(),
        initialDeposit: initialDepositController.text.trim(),
        bookingDays: bookingDaysController.text.trim(),
        userId: '', // Filled in repository
      );

      context.read<MakeBookingCubit>().createBooking(context, bookingRequest);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final textTheme =
        GoogleFonts.montserratTextTheme(Theme.of(context).textTheme);

    final fieldColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pushReplacementNamed(context, Routes.home),
        ),
        centerTitle: true,
        title: Text(
          "Make a Booking",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: BlocConsumer<MakeBookingCubit, MakeBookingState>(
        listener: (context, state) {
          if (state is MakeBookingSuccess) {
            CustomSnackBar.showSuccess(
              context,
              title: "Success",
              message:
                  "Kindly ask the customer to enter their Mpesa pin on prompt!",
            );
          } else if (state is MakeBookingError) {
            CustomSnackBar.showError(
              context,
              title: "Error",
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is MakeBookingLoading;
          return LayoutBuilder(
            builder: (context, constraints) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 22,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Header section
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Register a New Customer",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Fill in the details below to register a customer and create a booking for them.",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // Input fields
                        Column(
                          children: [
                            // First & Last Name
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: firstNameController,
                                    label: "First Name",
                                    hint: "John",
                                    icon: Icons.person_outline,
                                    fieldColor: fieldColor,
                                    textColor: textColor,
                                    errorText: firstNameError,
                                    onChanged: (_) {
                                      if (_showValidationErrors)
                                        _validateFields();
                                    },
                                    inputFormatters: [
                                      CapitalizeFirstLetterFormatter(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: lastNameController,
                                    label: "Last Name",
                                    hint: "Doe",
                                    icon: Icons.person_outline,
                                    fieldColor: fieldColor,
                                    textColor: textColor,
                                    errorText: lastNameError,
                                    onChanged: (_) {
                                      if (_showValidationErrors)
                                        _validateFields();
                                    },
                                    inputFormatters: [
                                      CapitalizeFirstLetterFormatter(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            // Phone number
                            _buildTextField(
                              controller: phoneController,
                              label: "Customer Number",
                              hint: "0712345678",
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: phoneError,
                              onChanged: (_) {
                                if (_showValidationErrors) _validateFields();
                              },
                            ),
                            SizedBox(height: 12.h),

                            // Product name
                            _buildTextField(
                              controller: productNameController,
                              label: "Product Name & Code",
                              hint: "Enter product name and code",
                              icon: Icons.shopping_cart_outlined,
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: productNameError,
                              onChanged: (_) {
                                if (_showValidationErrors) _validateFields();
                              },
                              inputFormatters: [
                                CapitalizeFirstLetterFormatter(),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            // Price & Deposit
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: bookingPriceController,
                                    label: "Product Price",
                                    hint: "100.00",
                                    icon: Icons.payment_rounded,
                                    keyboardType: TextInputType.number,
                                    fieldColor: fieldColor,
                                    textColor: textColor,
                                    errorText: bookingPriceError,
                                    onChanged: (_) {
                                      if (_showValidationErrors)
                                        _validateFields();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: initialDepositController,
                                    label: "Booking Deposit",
                                    hint: "50.00",
                                    icon: Icons.payment_rounded,
                                    keyboardType: TextInputType.number,
                                    fieldColor: fieldColor,
                                    textColor: textColor,
                                    errorText: initialDepositError,
                                    onChanged: (_) {
                                      if (_showValidationErrors)
                                        _validateFields();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            // Booking Days
                            _buildTextField(
                              controller: bookingDaysController,
                              label: "Duration of Payment",
                              hint: "Enter number of days",
                              icon: Icons.calendar_today_outlined,
                              keyboardType: TextInputType.number,
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: bookingDaysError,
                              onChanged: (_) {
                                if (_showValidationErrors) _validateFields();
                              },
                            ),
                            SizedBox(height: 12.h),
                          ],
                        ),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorName.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: isLoading ? null : _submit,
                            child: isLoading
                                ? const SpinKitWave(
                                    color: Colors.white,
                                    size: 22,
                                  )
                                : Text(
                                    "Register Customer",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Back to home
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Back to home? ",
                              style: textTheme.bodyMedium?.copyWith(
                                color: textColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                Routes.home,
                              ),
                              child: Text(
                                "Home",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: ColorName.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // TextField builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
    List<CapitalizeFirstLetterFormatter> inputFormatters = const [],
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.montserrat(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            prefixIcon: Icon(icon, color: Colors.blue[800]),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
          inputFormatters: inputFormatters,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }
}