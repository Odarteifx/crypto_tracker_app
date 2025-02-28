import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/widgets/translucent_nav_bar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text('Search'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text('Search Screen Coming Soon'),
          ),
          TranslucentNavBar(currentRoute: '/search'),
        ],
      ),
    );
  }
} 