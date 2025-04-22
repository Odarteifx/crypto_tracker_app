import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../constants/colors.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final dynamic category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.sp,
                ),
                child: SizedBox(
                  height: 30.sp,
                  child: Row(
                    spacing: 7.sp,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Top Coins',
                        style: TextStyle(
                          color: AppColors.inactiveIcon,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 6.sp,
                      ),
                      Text(
                        'Category',
                        style: TextStyle(
                          color: AppColors.inactiveIcon,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          '24H',
                          style: TextStyle(
                            color: AppColors.inactiveIcon,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Market Cap',
                        style: TextStyle(
                          color: AppColors.inactiveIcon,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.sp,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShadIconButton.ghost(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      LucideIcons.chevronLeft,
                      size: 28.sp,
                      color: AppColors.inactiveIcon,
                    ),
                  ),
                  Row(
                    spacing: 8.sp,
                    children: [
                      SizedBox(
                        width: 200.sp,
                        child: Text(
                          category['name'],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18.sp),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 4.sp,
                    children: [
                      ShadIconButton.ghost(
                        icon: Icon(
                          LucideIcons.search,
                          color: AppColors.inactiveIcon,
                          size: 20.sp,
                        ),
                        width: 30.sp,
                        height: 30.sp,
                      ),
                      ShadIconButton.ghost(
                        onPressed: () {},
                        icon: Icon(
                          LucideIcons.star,
                          color: AppColors.inactiveIcon,
                          size: 20.sp,
                        ),
                        width: 30.sp,
                        height: 30.sp,
                      ),
                      ShadIconButton.ghost(
                        icon: Icon(
                          LucideIcons.squareArrowOutUpRight,
                          color: AppColors.inactiveIcon,
                          size: 20.sp,
                        ),
                        width: 30.sp,
                        height: 33.sp,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: category['top_3_coins'].length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                       ShadAvatar(category['top_3_coins'][index], size: Size(30.sp, 30.sp),),
                       Column(
                        children: [
                          Text(
                            category['top_3_coins_id'][index],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            category['top_3_coins_id'][index],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                       ),
                    ],
                  );
                },
              ),
            ),
            Column(
              children: [
                Text('data'),
                Text('data')
              ],
            )
          ],
        ),
      ),
    );
  }
}
