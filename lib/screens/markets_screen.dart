import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 20.sp),
          child: Container(
            decoration: BoxDecoration(
              color:  Colors.black,
              borderRadius: BorderRadius.circular(28.sp),
            ),
            height: 65.sp,
          ),
        ),
        appBar: AppBar(
          leading: Image.asset(
            'assets/trezorm.png',
            width: 40,
          ),
          actions: [],
        ),
        body: Column(
          children: [],
        ));
  }
}
