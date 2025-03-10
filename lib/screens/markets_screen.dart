import 'dart:convert';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_tracker_app/constants/assets.dart';
import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/widgets/translucent_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
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

  String formatMarketCap(double marketCap) {
    if (marketCap >= 1e12) {
      return '\$${(marketCap / 1e12).toStringAsFixed(2)}T';
    } else if (marketCap >= 1e9) {
      return '\$${(marketCap / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap >= 1e6) {
      return '\$${(marketCap / 1e6).toStringAsFixed(2)}M';
    } else {
      return '\$${marketCap.toStringAsFixed(2)}';
    }
  }

  Future<List<dynamic>> fetchCoins() async {
    final apiKey = 'CG-Pma3VxhM2G1smijiQTM4f8fb';
    String url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&sparkline=true&price_change_percentage=7d';
    final uri = Uri.parse(url);

    try {
      final response =
          await http.get(uri, headers: {'x_cg_demo_api_key': apiKey, 'accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint(data.toString());
        return data;
      } else {
        throw Exception('Fialed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching coins: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

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
                letterSpacing: -0.3.sp,
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
            child: FutureBuilder<List<dynamic>>(
              future: fetchCoins(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator( color: AppColors.appColor,));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final coins = snapshot.data!;

                  return ListView.builder(
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      final upTrend = coins[index]['price_change_percentage_24h'] > 0;
                      final chartColor = upTrend ? AppColors.chartUpTrend : AppColors.chartDownTrend;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                        child: SizedBox(
                          height: 50.sp,
                          child: Row(
                            spacing: 20,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(coins[index]['market_cap_rank'].toString()),
                              Image.network(coins[index]['image'], height: 25.sp,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(coins[index]['symbol'].toUpperCase()),
                                   Text('\$${coins[index]['current_price'].toString()}'),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  formatMarketCap(coins[index]['market_cap'].toDouble()),
                                  style: TextStyle(
                                    color: AppColors.inactiveIcon,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25.sp,
                                width: 50.sp,
                                child: Sparkline(
                                  lineColor: chartColor,
                                  lineGradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      chartColor,
                                      chartColor.withValues(alpha: 0.2),
                                    ],
                                  ),
                                  fillColor: chartColor.withValues(alpha: 0.1),
                                  fillMode: FillMode.below,
                                  data: List<double>.from(
                                    coins[index]['sparkline_in_7d']['price'].map((e) => e.toDouble()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ));
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
