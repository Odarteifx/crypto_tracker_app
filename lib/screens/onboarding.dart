import 'package:crypto_tracker_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

class CryptoOnboarding extends StatefulWidget {
  const CryptoOnboarding({super.key});

  @override
  State<CryptoOnboarding> createState() => _CryptoOnboardingState();
}

class _CryptoOnboardingState extends State<CryptoOnboarding> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (mounted) {
          context.go('/markets');
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a73e8),
      body:
          Center(child: RiveAnimation.asset(Assets.trezoranimation)),
    );
  }
}
