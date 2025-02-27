import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CryptoOnboarding extends StatefulWidget {
  const CryptoOnboarding({super.key});

  @override
  State<CryptoOnboarding> createState() => _CryptoOnboardingState();
}

class _CryptoOnboardingState extends State<CryptoOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a73e8),
      body: Center(
        child: RiveAnimation.asset('assets/onboarding_animation.riv')
      ),
    );
  }
}
