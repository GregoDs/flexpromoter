import 'package:flexpromoter/features/auth/ui/otpverification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/auth/cubit/auth_cubit.dart';
import 'package:flexpromoter/features/auth/repo/auth_repo.dart';
import 'package:flexpromoter/features/auth/ui/login.dart';
import 'package:flexpromoter/features/home/ui/home.dart';
import 'package:flexpromoter/features/onboarding/splash_screen.dart';
import 'package:flexpromoter/features/onboarding/onboarding_screen.dart';

// Create a global AuthCubit instance
final authCubit = AuthCubit(AuthRepo());

class AppRoutes {
  static final routes = {
    Routes.splash: (context) => const SplashScreen(),
    Routes.onboarding: (context) => const OnBoardingScreen(),
    Routes.login: (context) => BlocProvider.value(
          value: authCubit,
          child: const LoginScreen(),
        ),
    Routes.otp: (context) => BlocProvider.value(
          value: authCubit,
          child: const OtpScreen(),
        ),
    Routes.home: (context) => const HomeScreen(),
    // Routes.makeBookings: (context) => const MakeBookings(),
    // Routes.validatedReceipts: (context) => ValidatedReceiptsPage(
    //       validatedReceipts: _validatedReceipts,
    //     ),
    // Routes.bookings: (context) => const Bookings(),
    // Routes.commissions: (context) => const Commissions(),
    // Routes.leaderboard: (context) => const Leaderboard(),
  };
}

class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const home = '/home';
  static const makeBookings = '/make-bookings';
  static const validatedReceipts = '/validated-receipts';
  static const bookings = '/bookings';
  static const commissions = '/commissions';
  static const leaderboard = '/leaderboard';
}
