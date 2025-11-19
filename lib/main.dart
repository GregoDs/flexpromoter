import 'package:flexpromoter/features/onboarding/splash_screen.dart';
import 'package:flexpromoter/gen/colors.gen.dart';
import 'package:flutter/services.dart';
import 'exports.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  runApp(const OverlaySupport.global(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          child: MaterialApp(
            title: 'Flexpay Promoter',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: ColorName.primaryColor,
              scaffoldBackgroundColor: ColorName.whiteColor,
            ),
            themeMode: ThemeMode.light,
            routes: AppRoutes.routes,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}