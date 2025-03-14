import 'dart:convert';

import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/models/coins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shadcn_ui/shadcn_ui.dart';

class CoinDetails extends StatefulWidget {
  final CoinModel coin;
  const CoinDetails({super.key, required this.coin});

  @override
  State<CoinDetails> createState() => _CoinDetailsState();
}

class _CoinDetailsState extends State<CoinDetails> {
  Future<Map<String, dynamic>?>? _coinsFuture;
  Map<String, dynamic>? coinDetails;
  bool swapCurrency = true;
  bool priceChangePercent = true;

  String formatPrice(price) {
    if (price < 1) {
      return '\$$price';
    }
    final NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");
    return '\$${numberFormat.format(price)}';
  }

  rankWidth(marketRank) {
    if (marketRank >= 1 && marketRank <= 9) {
      return 22.sp;
    } else if (marketRank >= 10 && marketRank < 100) {
      return 32.sp;
    } else {
      return 40.sp;
    }
  }

  Future<Map<String, dynamic>?> getCoinDetails() async {
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url = 'https://api.coingecko.com/api/v3/coins/${widget.coin.id}';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: {'x-cg-demo-api-key': apiKey, 'accept': 'application/json'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          coinDetails = jsonData;
          debugPrint('Coin details updated');
          debugPrint(coinDetails.toString());
        });

        return coinDetails;
      } else {
        throw Exception('Failed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching coins: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('initState called');
    _coinsFuture = getCoinDetails();
  }

  Future<void> _refreshCoin() async {
    setState(() {
      _coinsFuture = getCoinDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
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
                          width: 22.sp,
                          child: Image.network(
                            widget.coin.image,
                          )),
                      Text(
                        widget.coin.symbol.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18.sp),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8.sp,
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
                          Icons.share,
                          color: AppColors.inactiveIcon,
                          size: 20.sp,
                        ),
                        width: 30.sp,
                        height: 30.sp,
                      )
                    ],
                  )
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: _refreshCoin,
              child: FutureBuilder(
                future: _coinsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                        color: AppColors.appColor,
                      )),
                    );
                  } else if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final coin = snapshot.data!;

                    final price = coin['market_data']['current_price']['usd'];
                    final btcPrice =
                        coin['market_data']['current_price']['btc'];
                    final int marketRank = coin['market_cap_rank'];
                    final percentageChange =
                        coin['market_data']['price_change_percentage_24h'];
                      final  priceChange = coin['market_data']['price_change_24h']; 
                    final upTrend = percentageChange > 0;
                    final trendColor = upTrend
                        ? AppColors.chartUpTrend
                        : AppColors.chartDownTrend;
                    final trendIcon =
                        upTrend ? LucideIcons.arrowUp : LucideIcons.arrowDown;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                coin['id'].toString().capitalize(),
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.iconColor),
                              ),
                              SizedBox(
                                width: 10.sp,
                              ),
                              Container(
                                height: 20.sp,
                                width: rankWidth(marketRank),
                                decoration: BoxDecoration(
                                  color: AppColors.shadowColor,
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                                child: Center(
                                    child: Text(
                                  '#$marketRank',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.inactiveIcon,
                                      fontWeight: FontWeight.w500),
                                )),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    swapCurrency
                                        ? '${btcPrice.toString()} ₿'
                                        : formatPrice(price),
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    spacing: 5.sp,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            swapCurrency = !swapCurrency;
                                          });
                                        },
                                        child: Icon(LucideIcons.arrowDownUp,
                                            color: AppColors.inactiveIcon,
                                            size: 18.sp),
                                      ),
                                      Text(
                                        swapCurrency
                                            ? formatPrice(price)
                                            : '${btcPrice.toString()} ₿',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: AppColors.inactiveIcon),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    priceChangePercent = !priceChangePercent;
                                  });
                                },
                                child: Container(
                                  height: 35.sp,
                                  width:  priceChangePercent ? 70.sp : 120.sp,
                                  decoration: BoxDecoration(
                                    color: trendColor,
                                    borderRadius: BorderRadius.circular(6.sp),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        trendIcon,
                                        color: AppColors.backgroundColor,
                                        size: 18.sp,
                                      ),
                                      Text(
                                       priceChangePercent? '${percentageChange.toStringAsFixed(2)}%' : formatPrice(priceChange) ,
                                        style: TextStyle(
                                            color: AppColors.backgroundColor,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
