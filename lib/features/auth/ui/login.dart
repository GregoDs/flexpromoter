import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/auth/cubit/auth_cubit.dart';
import 'package:flexpromoter/features/auth/cubit/auth_state.dart';
import 'package:flexpromoter/utils/widgets/scaffold_messengers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isSnackBarShowing = false; // Flag to track if a SnackBar is showing

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              // Update loading state
              setState(() {
                _isLoading = true;
              });
            } else if (state is AuthOtpSent) {
              // Update loading state
              setState(() {
                _isLoading = false;
              });

              // Show success message
              CustomSnackBar.showSuccess(
                context,
                title: 'Success',
                message: state.message,
              );

              // Delay navigation until the success SnackBar is shown
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushNamed(
                    context, '/otp'); // Use the named route here
              });
            } else if (state is AuthError && !_isSnackBarShowing) {
              // Update loading state
              setState(() {
                _isLoading = false;
                _isSnackBarShowing = true;
              });

              // Show error message
              CustomSnackBar.showError(
                context,
                title: 'Error',
                message: state.errorMessage,
                actionLabel: 'Dismiss',
                onAction: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  setState(() {
                    _isSnackBarShowing = false;
                  });
                },
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/images/happyafricanlogin.png',
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: "Sign In to Flexpay ",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "We provide top-quality services and support for your needs.",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: screenWidth * 0.05,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  TextFormField(
                    controller: phoneController,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: screenWidth * 0.045,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      labelText: "Phone Number",
                      hintText: "Enter your phone number",
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: screenWidth * 0.045,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                    ),
                    enabled: !_isLoading,
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              // Handle Forgot Password
                            },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: screenWidth * 0.04,
                          color: const Color(0xFF337687),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF337687),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.018,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              final phoneNumber = phoneController.text.trim();
                              if (phoneNumber.isNotEmpty) {
                                // Save phone number to SharedPreferences
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setString('phone_number', phoneNumber);
                                });

                                context
                                    .read<AuthCubit>()
                                    .requestOtp(phoneNumber);
                              } else {
                                CustomSnackBar.showError(
                                  context,
                                  title: 'Error',
                                  message: 'Please enter your phone number',
                                );
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "LOGIN",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              // Handle Sign Up
                            },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: screenWidth * 0.045,
                          color: const Color(0xFF337687),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
