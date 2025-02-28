import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/widgets/translucent_nav_bar.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text('News'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text('News Screen Coming Soon'),
          ),
          TranslucentNavBar(currentRoute: '/news'),
        ],
      ),
    );
  }
} 