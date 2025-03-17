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
  bool swapCurrency = false;
  bool priceChangePercent = true;

  int _selectedTabIndex = 0;
  final List<String> _tabs = ['24H', '7D', '1M', '1Y', 'Max'];
  final Map<IconData, String> chartType = {
    LucideIcons.chartSpline: 'Price',
    LucideIcons.chartCandlestick: 'Price',
  };

  final Map<String, String> marketPercentage = {
    '24H': 'price_change_percentage_24h',
    '7D': 'price_change_percentage_7d',
    '14D': ' price_change_percentage_14d',
    '30D': 'price_change_percentage_30d',
    '60D': 'price_change_percentage_60d',
    'YTD': 'price_change_percentage_1',
  };

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

  priceWidth(price) {
    if (price.length <= 5) {
      return 80.sp;
    } else if (price.length >= 6 && price.length <= 9) {
      return 120.sp;
    } else if (price.length >= 10) {
      return 150.sp;
    } else {
      200.sp;
    }
  }

  String formatBtcNumber(price) {
    if (price == 0) return "0.00";

    if (price < 0.000001) {
      return price
          .toStringAsFixed(8); // Show 8 decimal places for very small numbers
    } else {
      final NumberFormat numberFormat = NumberFormat("#,##0", "en_US");
      return numberFormat
          .format(price); // Show 2 decimal places for regular numbers
    }
  }

String formatSuppy(double marketCap) {
    if (marketCap >= 1e12) {
      return '\$${(marketCap / 1e12).toStringAsFixed(1)} Trillion';
    } else if (marketCap >= 1e9) {
      return '\$${(marketCap / 1e9).toStringAsFixed(1)} Billion';
    } else if (marketCap >= 1e6) {
      return '\$${(marketCap / 1e6).toStringAsFixed(1)} Million';
    } else {
      return '\$${marketCap.toStringAsFixed(2)}';
    }
  }
  percentagePriceformat(price) {
    final ppf = price.toString();
    if (price < 1 && ppf.length <= 9) {
      return '\$$price';
    } else if (price < 1 && price > -1 && ppf.length > 9) {
      final NumberFormat numberFormat = NumberFormat("#,##0.00000", "en_US");
      return '\$${numberFormat.format(price)}';
    } else {
      final NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");
      return '\$${numberFormat.format(price)}';
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
          // debugPrint(coinDetails.toString());
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
                  )
                ],
              ),
            ),

            // Add refreshIndicator later
            FutureBuilder(
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
                  final btcPrice = coin['market_data']['current_price']['btc'];
                  final int marketRank = coin['market_cap_rank'];

                  final marketCapUSD = coin['market_data']['market_cap']['usd'];
                  final marketCapBTC = coin['market_data']['market_cap']['btc'];

                  final fDilutedUSD = coin['market_data']['fully_diluted_valuation']['usd'];
                  final fDilutedBTC = coin['market_data']['fully_diluted_valuation']['btc'];

                  final marketCapFdvRatio = coin['market_data']['market_cap_fdv_ratio'];

                  final totalVolumeBtc = coin['market_data']['total_volume']['btc'];
                  final totalVolumeUSD = coin['market_data']['total_volume']['usd'];

                   final h24Btc = coin['market_data']['high_24h']['btc'];
                   final l24BTC = coin['market_data']['low_24h']['btc']; 
                  final h24USD = coin['market_data']['high_24h']['usd'];
                  final l24USD= coin['market_data']['low_24h']['usd'];

                   final athBtc = coin['market_data']['ath']['btc'];
                   final atlBTC = coin['market_data']['atl']['btc']; 
                  final athUSD = coin['market_data']['ath']['usd'];
                  final atlUSD= coin['market_data']['atl']['usd'];

                  final percentageChange = coin['market_data']['price_change_percentage_24h'];

                  final circulatingSupply= coin['market_data']['circulating_supply'];
                  final maxSupply= coin['market_data']['max_supply'];
                  final totalSupply= coin['market_data']['total_supply'];

                   final creationDate = coin['market_data']['genesis_date'];

                  final priceChange = coin['market_data']['price_change_24h'];
                  final priceChangeBtc = coin['market_data']['price_change_24h_in_currency']['btc'];
                  final priceChangeBtcPercent = coin['market_data']['price_change_percentage_24h_in_currency']['btc'];
                  final upTrend = percentageChange > 0;

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: Column(
                          spacing: 10.sp,
                          children: [
                            Column(children: [
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        priceChangePercent =
                                            !priceChangePercent;
                                      });
                                    },
                                    child: Container(
                                      height: 35.sp,
                                      width: swapCurrency
                                          ? (priceChangePercent
                                              ? 70.sp
                                              : priceWidth(priceChangePercent
                                                  ? '${priceChangeBtcPercent.toStringAsFixed(2)}%'
                                                  : percentagePriceformat(
                                                      priceChangeBtc)))
                                          : (priceChangePercent
                                              ? 70.sp
                                              : priceWidth(priceChangePercent
                                                  ? '${percentageChange.toStringAsFixed(2)}%'
                                                  : percentagePriceformat(
                                                      priceChange))),
                                      decoration: BoxDecoration(
                                        color: marketColor(
                                            percentageChange, upTrend),
                                        borderRadius:
                                            BorderRadius.circular(6.sp),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            marketIcon(
                                                percentageChange, upTrend),
                                            color: AppColors.backgroundColor,
                                            size: 18.sp,
                                          ),
                                          Text(
                                            swapCurrency
                                                ? (priceChangePercent
                                                    ? '${priceChangeBtcPercent.toStringAsFixed(2)}%'
                                                    : '${formatBtcNumber(priceChangeBtc)} ₿')
                                                : (priceChangePercent
                                                    ? '${percentageChange.toStringAsFixed(2)}%'
                                                    : percentagePriceformat(
                                                        priceChange)),
                                            style: TextStyle(
                                                color:
                                                    AppColors.backgroundColor,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ]),
                            Container(
                              height: 220.sp,
                              decoration: BoxDecoration(
                                  color: AppColors.shadowColor,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(child: Text('chart here')),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                height: 45.sp,
                                decoration: BoxDecoration(
                                    // color: AppColors.shadowColor,
                                    borderRadius: BorderRadius.circular(8.r)),
                                child: Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 105.sp,
                                      ),
                                      child: ShadSelect<dynamic>(
                                          initialValue: LucideIcons.chartSpline,
                                          options: [
                                            ShadOption(
                                                value: LucideIcons
                                                    .chartCandlestick,
                                                child: Row(
                                                  spacing: 3.sp,
                                                  children: [
                                                    Text('Price'),
                                                    Icon(LucideIcons
                                                        .chartCandlestick)
                                                  ],
                                                )),
                                            ShadOption(
                                                value: LucideIcons.chartSpline,
                                                child: Row(
                                                  spacing: 3.sp,
                                                  children: [
                                                    Text('Price'),
                                                    Icon(
                                                        LucideIcons.chartSpline)
                                                  ],
                                                )),
                                            ShadOption(
                                                value: LucideIcons.baby,
                                                child: Text('Market Cap'))
                                          ],
                                          selectedOptionBuilder:
                                              (context, value) => Icon(value)),
                                    ),
                                    SizedBox(
                                      width: 235.sp,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return _buildTab(index);
                                        },
                                        itemCount: _tabs.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 60.sp,
                              decoration: BoxDecoration(
                                  color: AppColors.shadowColor,
                                  borderRadius: BorderRadius.circular(8.sp)),
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.sp,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: marketPercentage.length,
                                itemBuilder: (context, index) {
                                  String frame =
                                      marketPercentage.keys.elementAt(index);
                                  String framePercentage =
                                      marketPercentage.values.elementAt(index);
                                  final marketChangePercentage =
                                      coin['market_data'][framePercentage];
                                  final bool marketBullish =
                                      marketChangePercentage == null
                                          ? marketChangePercentage == 0
                                          : marketChangePercentage ==
                                              marketChangePercentage;

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.5.sp),
                                    child: Column(
                                      spacing: 2.sp,
                                      children: [
                                        Text(
                                          frame,
                                          style: TextStyle(
                                              color: AppColors.iconColor,
                                              fontSize: 13.sp),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              size: 14.sp,
                                              marketIcon(marketChangePercentage,
                                                  marketBullish),
                                              color: marketColor(
                                                  marketChangePercentage,
                                                  marketBullish),
                                            ),
                                            Text(
                                              marketChangePercentage == null
                                                  ? '0.0%'
                                                  : '${marketChangePercentage.toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                  color: marketColor(
                                                      marketChangePercentage,
                                                      marketBullish),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 600.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.sp),
                                color: AppColors.shadowColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.sp),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Market Cap Rank',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            '#${marketRank.toString()}',
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Market Cap',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            swapCurrency
                                                ? '${formatBtcNumber(marketCapBTC)} ₿'
                                                : formatPrice(marketCapUSD),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Fully Diluted Valuation',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            swapCurrency
                                                ? '${formatBtcNumber(fDilutedBTC)} ₿'
                                                : formatPrice(fDilutedUSD),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Market Cap/ FDV Ratio',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            marketCapFdvRatio
                                                .toStringAsFixed(0),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Trading Volume',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            swapCurrency
                                                ? '${formatBtcNumber(totalVolumeBtc)} ₿'
                                                : formatPrice(totalVolumeUSD),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '24 High',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            swapCurrency
                                                ? '${formatBtcNumber(h24Btc)} ₿'
                                                : formatPrice(h24USD),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '24H Low',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            swapCurrency
                                                ? '${formatBtcNumber(l24BTC)} ₿'
                                                : formatPrice(l24USD),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Circulating Supply',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            formatSuppy(circulatingSupply),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Supply',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            formatSuppy(totalSupply),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Max Supply',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            maxSupply ==null ? maxSupply.toString() : formatSuppy(maxSupply),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'All-Time High',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            swapCurrency
                                                ? '${formatBtcNumber(athBtc)} ₿'
                                                : formatPrice(athUSD),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'All-Time Low',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            swapCurrency
                                                ? '${formatBtcNumber(atlBTC)} ₿'
                                                : formatPrice(atlUSD),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Genesis Date',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.inactiveIcon),
                                          ),
                                          Text(
                                            creationDate.toString(),
                                            style: TextStyle(
                                                color: AppColors.iconColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  IconData marketIcon(marketChangePercentage, bool marketBullish) {
    return (marketChangePercentage == null || marketChangePercentage == 0)
        ? LucideIcons.minus
        : marketChangePercentage > 0
            ? LucideIcons.arrowUp
            : LucideIcons.arrowDown;
  }

  Color marketColor(marketChangePercentage, bool marketBullish) {
    return (marketChangePercentage == null || marketChangePercentage == 0)
        ? AppColors.iconColor
        : marketChangePercentage > 0
            ? AppColors.chartUpTrend
            : AppColors.chartDownTrend;
  }

  Widget _buildTab(int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sp),
        child: Container(
          width: 40.sp,
          margin: EdgeInsets.symmetric(horizontal: 3.sp),
          decoration: BoxDecoration(
              color: isSelected ? AppColors.appColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected
                      ? AppColors.backgroundColor
                      : AppColors.inactiveIcon,
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: -0.3.sp,
                ),
              ),
            ],
          ),
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
