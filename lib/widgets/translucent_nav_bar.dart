import 'dart:ui';
import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TranslucentNavBar extends StatelessWidget {
  final String currentRoute;

  const TranslucentNavBar({
    super.key,
    required this.currentRoute,
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
          filter: ImageFilter.blur(sigmaX: 5.sp, sigmaY: 5.sp),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 15.sp),
            decoration: BoxDecoration(
              color: AppColors.navbarColor,
              borderRadius: BorderRadius.circular(40.sp),
              border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.5),
                  width: 1.5.sp),
              gradient: LinearGradient(
                colors: [const Color.fromRGBO(255, 255, 255, 0.4), const Color.fromRGBO(255, 255, 255, 0.1)],
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
                _buildNavItem(context, LucideIcons.chartArea, 'Markets', '/markets'),
                const Spacer(),
                _buildNavItem(context, LucideIcons.newspaper, 'News', '/news'),
                const Spacer(),
                _buildNavItem(context, LucideIcons.search, 'Search', '/search'),
                const Spacer(),
                _buildNavItem(context, LucideIcons.settings, 'Settings', '/settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, String route) {
    final bool isActive = currentRoute == route;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          context.go(route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: isActive ? AppColors.appColor : AppColors.inactiveIcon,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: isActive ? AppColors.appColor : AppColors.inactiveIcon,
            ),
          ),
        ],
      ),
    );
  }
} 