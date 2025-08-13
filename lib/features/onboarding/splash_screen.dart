import 'dart:async';
import 'package:flexpromoter/exports.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isLoggedIn = false;
  bool firstLaunch = false;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    _checkLoginStatus();
    _checkForUpdate();
  }

  /// Check for Google Play in-app updates
 Future<void> _checkForUpdate() async {
  try {
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      // Show a custom prompt before forcing the update
      _showUpdateDialog();
    } else {
      // Skip the 7-second delay if no update is needed
      _navigateImmediately();
    }
  } catch (e) {
    print("Update check failed: $e");
    _navigateImmediately();
  }
}

void _navigateImmediately() {
  // Small delay (e.g., 500ms) so the splash animation shows briefly
  Timer(
    const Duration(milliseconds: 5000),
    () => firstLaunch
        ? Navigator.pushReplacementNamed(context, Routes.onboarding)
        : isLoggedIn
            ? Navigator.pushReplacementNamed(context, Routes.home)
            : Navigator.pushReplacementNamed(context, Routes.login),
  );
}

void _showUpdateDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // can't dismiss without action
    builder: (context) => AlertDialog(
      title: const Text("Update Available"),
      content: const Text(
        "A new version of the app is available. Please update to continue.",
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await InAppUpdate.performImmediateUpdate();
            // After update, Play Store restarts app automatically
          },
          child: const Text("Update Now"),
        ),
      ],
    ),
  );
}

  void _startNavigationTimer() {
    Timer(
      const Duration(seconds: 7),
      () => firstLaunch
          ? Navigator.pushReplacementNamed(context, Routes.onboarding)
          : isLoggedIn
              ? Navigator.pushReplacementNamed(context, Routes.home)
              : Navigator.pushReplacementNamed(context, Routes.login),
    );
  }

  _checkLoginStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var launch = localStorage.getBool('firstLaunch');
    var token = localStorage.getString('token');

    setState(() {
      firstLaunch = launch ?? true;
      isLoggedIn = token != null && token.isNotEmpty;
      print("Token: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ScaleTransition(
                  scale: animation,
                  child: Center(
                    child: Container(
                      width: 330,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.images.flexpay.path),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 180.h),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class StartupRedirector extends StatefulWidget {
//   const StartupRedirector({super.key});

//   @override
//   State<StartupRedirector> createState() => _StartupRedirectorState();
// }

// class _StartupRedirectorState extends State<StartupRedirector> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateAfterDelay();
//   }

//   Future<void> _navigateAfterDelay() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     final launch = localStorage.getBool('firstLaunch') ?? true;
//     final token = localStorage.getString('token');

//     // Slight delay to ensure build has settled (optional but helps)
//     await Future.delayed(const Duration(milliseconds: 100));

//     if (launch) {
//       Navigator.pushReplacementNamed(context, Routes.onboarding);
//     } else if (token != null && token.isNotEmpty) {
//       Navigator.pushReplacementNamed(context, Routes.home);
//     } else {
//       Navigator.pushReplacementNamed(context, Routes.login);
//     }

//     // Remove splash AFTER push to avoid flicker
//     FlutterNativeSplash.remove();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Do not return any visual layout to avoid white screen
//     return const SizedBox.shrink(); // fully transparent
//   }
// }