import 'package:crypto_tracker_app/constants/assets.dart';
import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/widgets/translucent_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = [
    'Coins',
    'Watchlists',
    'Overview',
    'Exchanges',
    'Categories'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Image.asset(
            Assets.trezorm,
            width: 40,
          ),
          actions: [
            ShadIconButton.ghost(
                icon: Icon(
                  LucideIcons.arrowUpDown,
                  size: 22.sp,
                  color: AppColors.inactiveIcon,
                ),
                onPressed: () {}),
            Padding(
              padding: EdgeInsets.only(right: 15.sp),
              child: ShadIconButton.ghost(
                  icon: Icon(
                    LucideIcons.search,
                    size: 22.sp,
                    color: AppColors.inactiveIcon,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                    height:
                        kToolbarHeight + MediaQuery.of(context).padding.top),
                Container(
                  height: 45.sp,
                  margin: EdgeInsets.only(bottom: 15.sp),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tabs.length,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    itemBuilder: (context, index) {
                      return _buildTab(index);
                    },
                  ),
                ),
                Expanded(
                  child: _buildTabContent(),
                ),
              ],
            ),
            TranslucentNavBar(currentRoute: '/markets'),
          ],
        ));
  }

  Widget _buildTab(int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 30.sp),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.appColor : Colors.transparent,
              width: 2.sp,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _tabs[index],
              style: TextStyle(
                color: isSelected ? AppColors.appColor : AppColors.inactiveIcon,
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            // You can add custom scroll behavior here if needed
            return false;
          },
          child: ListView.builder(
            itemCount: 50,
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.sp),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.appColor.withOpacity(0.1),
                    child: Icon(LucideIcons.bitcoin, color: AppColors.appColor),
                  ),
                  title: Text(
                    'Bitcoin',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  subtitle: Text(
                    'BTC',
                    style: TextStyle(
                      color: AppColors.inactiveIcon,
                      fontSize: 12.sp,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$45,230.65',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        '+2.5%',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      case 1:
        return Center(child: Text('Watchlist Coming Soon'));
      case 2:
        return Center(child: Text('Overview Coming Soon'));
      case 3:
        return Center(child: Text('Exchanges Coming Soon'));
      case 4:
        return Center(child: Text('Categories Coming Soon'));
      default:
        return SizedBox();
    }
  }
}
