import 'dart:ui';

import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          leading: Image.asset(
            'assets/trezorm.png',
            width: 40,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: ShadIconButton.ghost(
                  icon: Icon(
                    LucideIcons.search,
                    size: 25.sp,
                    color: AppColors.inactiveIcon,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return ListTile(
                  
                  title: Text('Item $index'),
                  trailing: Text('chart data', style: TextStyle(color: index % 2 == 0 ? Colors.pink : Colors.purple,),),
                );
              },
            ),
            TranslucentNavBar(),
          ],
        ));
  }
}

class TranslucentNavBar extends StatelessWidget {
  const TranslucentNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25.sp,
      left: 50.sp,
      right: 50.sp,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.sp),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.sp, sigmaY: 30.sp),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 15.sp),
            decoration: BoxDecoration(
              color: AppColors.navbarColor,
              borderRadius: BorderRadius.circular(40.sp),
              border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.5),
                  width: 1.5.sp),
              gradient: LinearGradient(
                colors: [const Color.fromRGBO(255, 255, 255, 0.3), const Color.fromRGBO(255, 255, 255, 0.15)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 35,
                  spreadRadius: 0,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            height: 70.sp,
            child: Row(
              children: [
                _buildNavItem(LucideIcons.chartArea, 'Markets', isActive: true),
                const Spacer(),
                 _buildNavItem(LucideIcons.newspaper, 'News'),
                const Spacer(),
                _buildNavItem(LucideIcons.search, 'Search'),
                const Spacer(),
                _buildNavItem(LucideIcons.wallet, 'Wallet'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 20.sp,
        color: isActive ? AppColors.appColor : AppColors.inactiveIcon,
      ),
      // const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          color: isActive ? AppColors.appColor : AppColors.inactiveIcon,
        ),
      ),
    ],
  );
}
