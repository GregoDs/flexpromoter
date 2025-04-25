import 'package:flexpromoter/features/auth/ui/otpverification.dart';
import 'package:flexpromoter/features/bookings/cubit/make_booking_cubit.dart';
import 'package:flexpromoter/features/bookings/ui/booking_details.dart';
import 'package:flexpromoter/features/bookings/ui/bookings.dart';
import 'package:flexpromoter/features/bookings/ui/make_bookings.dart';
import 'package:flexpromoter/features/commissions/cubit/commissions_cubit.dart';
import 'package:flexpromoter/features/commissions/ui/commissions.dart';
import 'package:flexpromoter/features/leaderboard/ui/leaderboard_screen.dart';
import 'package:flexpromoter/features/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:flexpromoter/features/leaderboard/repo/leaderboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpromoter/features/auth/cubit/auth_cubit.dart';
import 'package:flexpromoter/features/auth/repo/auth_repo.dart';
import 'package:flexpromoter/features/auth/ui/login.dart';
import 'package:flexpromoter/features/home/ui/home.dart';
import 'package:flexpromoter/features/onboarding/splash_screen.dart';
import 'package:flexpromoter/features/onboarding/onboarding_screen.dart';
import 'package:flexpromoter/features/commissions/repo/commission_repo.dart';
import 'package:flexpromoter/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpromoter/features/bookings/repo/bookings_repo.dart';

// Create global Cubit instances
final authCubit = AuthCubit(AuthRepo());
final commissionsCubit = CommissionsCubit(repository: CommissionRepository());
final bookingsCubit = BookingsCubit(repository: BookingsRepository());

class AppRoutes {
  static final routes = {
    // Routes.splash: (context) => const StartupRedirector(),
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

    Routes.makeBookings: (context) => BlocProvider(
          create: (context) => MakeBookingCubit(BookingsRepository()),
          child: const MakeBookingsScreen(),
        ),

    // Routes.validatedReceipts: (context) => ValidatedReceiptsPage(
    //       validatedReceipts: _validatedReceipts,
    //     ),
    Routes.bookings: (context) => BlocProvider.value(
          value: bookingsCubit,
          child: const BookingsScreen(),
        ),

    Routes.bookingDetails: (context) => BlocProvider.value(
          value: bookingsCubit,
          child: const BookingDetailScreen(
            bookings: [],
            title: '',
          ),
        ),

    Routes.commissions: (context) => BlocProvider.value(
          value: commissionsCubit,
          child: const Commissions(),
        ),
    Routes.leaderboard: (context) => BlocProvider.value(
          value: LeaderboardCubit(repository: LeaderboardRepository()),
          child: const LeaderboardScreen(),
        ),
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
  static const bookingDetails = '/booking-details';
}
