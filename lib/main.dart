import 'package:flexpromoter/features/onboarding/splash_screen.dart';
import 'package:flexpromoter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

import 'exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const OverlaySupport.global(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            //statusBarColor: ColorName.primaryColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          child: MaterialApp(
            title: 'Flexpay Promoter',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: ColorName.primaryColor,
              scaffoldBackgroundColor: ColorName.whiteColor,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: ColorName.primaryColor,
              scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            ),
            themeMode: ThemeMode.system,
            routes: AppRoutes.routes,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
