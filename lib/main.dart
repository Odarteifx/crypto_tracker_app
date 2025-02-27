import 'package:crypto_tracker_app/router.dart';
import 'package:crypto_tracker_app/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(390, 844),
        builder: (context, child) {
          return ShadApp.router(
            title: 'Trezo',
            debugShowCheckedModeBanner: false,
            theme: ShadThemeData(
              brightness: Brightness.light,
              colorScheme: ShadBlueColorScheme.light(),
              textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.inter),
            ),
            routerConfig: router,
          );
        });
  }
}

class CryptoTracker extends StatefulWidget {
  const CryptoTracker({super.key});

  @override
  State<CryptoTracker> createState() => _CryptoTrackerState();
}

class _CryptoTrackerState extends State<CryptoTracker> {
  @override
  Widget build(BuildContext context) {
    return const CryptoOnboarding();
  }
}
