import 'package:crypto_tracker_app/screens/onboarding.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trexo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CryptoTracker(),
    );
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