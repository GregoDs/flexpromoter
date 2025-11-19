import 'dart:async';
import 'dart:io';
import 'package:flexpromoter/exports.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flexpromoter/utils/services/logger.dart';

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
  late Upgrader upgrader;

  @override
  void initState() {
    super.initState();

    upgrader = Upgrader(); 

    // Start splash immediately
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    // Run login check
    _checkLoginStatus();

    // Delay upgrade check slightly so splash can render first
    Future.delayed(const Duration(seconds: 4), () {
      _checkForVersionUpdate();
    });
  }

  //Check for Google Play in-app updates
  _checkForVersionUpdate() {
    // FOR TESTING ONLY: Hardcode version codes
    //checkForUpdate("FAKE_VERSION");
    // const playStoreVersionCode = 9; // Simulate a higher version available
    // const installedVersionCode = 8; // Simulate current installed version

    //For Production use
    final playStoreVersion = upgrader.versionInfo?.appStoreVersion;
    final installedVersion = upgrader.versionInfo?.installedVersion;

    AppLogger.log('Available update version: ${playStoreVersion?.toString()}');
    AppLogger.log('Installed app version: ${installedVersion?.toString()}');

    // if (playStoreVersionCode > installedVersionCode) {
    //   checkForUpdate('1.0.0+11');
    // } else {
    //   AppLogger.log("App is up to date");
    //   // Immediately navigate to the correct screen
    //   if (firstLaunch) {
    //     Navigator.pushReplacementNamed(context, Routes.onboarding);
    //   } else if (isLoggedIn) {
    //     Navigator.pushReplacementNamed(context, Routes.home);
    //   } else {
    //     Navigator.pushReplacementNamed(context, Routes.login);
    //   }
    // }

    if (playStoreVersion != null && installedVersion != null) {
      if (playStoreVersion > installedVersion) {
        checkForUpdate(playStoreVersion.toString());
      } else {
        AppLogger.log('App is up to date');
        _navigateImmediately();
      }
    } else {
      AppLogger.log('Version info is not available');
      _navigateImmediately();
    }
  }

  void checkForUpdate(String playStoreVersion) {
    String updateUrl = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.flexpay.flexpromoter'
        : 'https://apps.apple.com/app/app_store_id';

    _showUpdateDialog(updateUrl, playStoreVersion);
  }

  void _navigateImmediately() {
    Timer(
      const Duration(milliseconds: 0000),
      () => firstLaunch
          ? Navigator.pushReplacementNamed(context, Routes.onboarding)
          : isLoggedIn
              ? Navigator.pushReplacementNamed(context, Routes.home)
              : Navigator.pushReplacementNamed(context, Routes.login),
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
      AppLogger.log("Token: $token");
    });
  }

  void _showUpdateDialog(String updateUrl, String storeVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.fromLTRB(22, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icon/Flexpay Logo-01.png',
                    width: 36,
                    height: 36,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Update FlexPromoter?',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Download size: 9.2 MB',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FlexPromoter recommends that you update to the latest version. Kindly update for the necessary changes to be applied.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF388E3C), // Green
                      textStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Immediately navigate to the correct screen
                      if (firstLaunch) {
                        Navigator.pushReplacementNamed(
                            context, Routes.onboarding);
                      } else if (isLoggedIn) {
                        Navigator.pushReplacementNamed(context, Routes.home);
                      } else {
                        Navigator.pushReplacementNamed(context, Routes.login);
                      }
                    },
                    child: const Text('NO THANKS'),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C), // Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        minimumSize: const Size(88, 36),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        if (await canLaunchUrl(Uri.parse(updateUrl))) {
                          await launchUrl(Uri.parse(updateUrl),
                              mode: LaunchMode.externalApplication);
                        }
                        _startNavigationTimer();
                      },
                      child: const Text('UPDATE'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Center(
                child: Image.asset(
                  'assets/icon/Flexpay Logo-01.png',
                  width: 72,
                  height: 72,
                ),
              ),
            ],
          ),
        );
      },
    );
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
                          image: AssetImage(Assets.icon.flexpayLogo01.path),
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
