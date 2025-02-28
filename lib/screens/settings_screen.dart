import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/widgets/translucent_nav_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text('Settings'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text('Settings Screen Coming Soon'),
          ),
          TranslucentNavBar(currentRoute: '/settings'),
        ],
      ),
    );
  }
} 