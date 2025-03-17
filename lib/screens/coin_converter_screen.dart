// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:crypto_tracker_app/constants/colors.dart';

class CoinConverterScreen extends ConsumerWidget {
  const CoinConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadSheet(
      backgroundColor: AppColors.backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 25.sp),
      title: Text('Currency Converter'),
      child: Column(
        spacing: 10.sp,
        children: [
          Column(
            children: [
              SizedBox(
                height: 100.sp,
                child: Padding(
                  padding:  EdgeInsets.all(20.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('CoinOne'), Text('Unit')],
                  ),
                ),
              ),
              Container(
                height: 100.sp,
                color: AppColors.shadowColor,
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('CoinTwo'), Text('Unit')],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              spacing: 5.sp,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCalcButtn(num: 1,),
                    CustomCalcButtn(num: 2,),
                    CustomCalcButtn(num: 3,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCalcButtn(num: 4,),
                    CustomCalcButtn(num: 5,),
                    CustomCalcButtn(num: 6,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCalcButtn(num: 7,),
                    CustomCalcButtn(num: 8,),
                    CustomCalcButtn(num: 9,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCalcButtn(num: '.',),
                    CustomCalcButtn(num: 0,),
                    CustomCalcButtn(num: '<')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomCalcButtn extends StatelessWidget {
  final dynamic num;
  const CustomCalcButtn({
    super.key,
    required this.num,
  });

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      backgroundColor: AppColors.shadowColor,
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: BorderRadius.circular(50))
      ),
      onPressed: () {
         final output = num.toString();
         debugPrint(output);
      },
      pressedBackgroundColor: AppColors.shadowColor,
      width: 90.sp,
      height: 90.sp,
      child: Text(
        num.toString(),
        style: TextStyle(color: AppColors.iconColor, fontSize: 22.sp),
      ),
      
    );
  }
}
