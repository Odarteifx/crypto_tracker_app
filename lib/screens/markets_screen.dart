import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_tracker_app/constants/assets.dart';
import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/models/coins.dart';
import 'package:crypto_tracker_app/providers/coin_provider.dart';
import 'package:crypto_tracker_app/providers/exchanges_provider.dart';
import 'package:crypto_tracker_app/providers/nft_provider.dart';
import 'package:crypto_tracker_app/widgets/translucent_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MarketsScreen extends ConsumerStatefulWidget {
  const MarketsScreen({super.key});

  @override
  ConsumerState<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends ConsumerState<MarketsScreen> {
  int _selectedTabIndex = 0;
  Future<List<CoinModel>>? _coinsFuture;
  Future? _nftFuture;
  // Future? _nftDetailsFuture;
  Future? _exchangesFuture;

  final List<String> _tabs = [
    'Coins',
    'Watchlists',
    'NFT',
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

  String formatPrice(double price) {
    if (price < 1) {
      return '\$$price';
    }
    final NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");
    return '\$${numberFormat.format(price)}';
  }

  String formatSymbol(String symbol) {
    if (symbol.length > 7) {
      return '${symbol.substring(0, 7)}...';
    }
    return symbol;
  }

  updateNFT() {
    _nftFuture = ref.read(nftProvider.notifier).fetchNFTs();
  }

  updateExchanges() {
    _exchangesFuture = ref.read(exchangesProvider.notifier).fetchExchanges();
  }

  Future<void> _refreshCoins() async {
    setState(() {
      _coinsFuture = ref.read(coinProvider.notifier).fetchCoins();
    });
  }

  @override
  void initState() {
    super.initState();
    _coinsFuture = ref.read(coinProvider.notifier).fetchCoins();
    Future.delayed(Duration(seconds: 100), (){
      updateExchanges();
    });
    Future.delayed(Duration(seconds: 200), (){
      updateNFT();
    });
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
                  size: 20.sp,
                  color: AppColors.inactiveIcon,
                ),
                width: 30.sp,
                height: 30.sp,
                onPressed: () {
                  context.push('/coinConverter');
                }),
            Padding(
              padding: EdgeInsets.only(right: 15.sp),
              child: ShadIconButton.ghost(
                  icon: Icon(
                    LucideIcons.search,
                    size: 20.sp,
                    color: AppColors.inactiveIcon,
                  ),
                  width: 30.sp,
                  height: 30.sp,
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
                  margin: EdgeInsets.only(bottom: 8.sp),
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
        return coinsList();
      case 1:
        return Center(child: Text('Watchlists Coming Soon'));
      case 2:
        return FutureBuilder(
          future: _nftFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColors.appColor,
              ));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final nfts = snapshot.data!;
              return ListView.builder(
                itemCount: nfts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(nfts[index].name),
                    subtitle: Text(nfts[index].symbol),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        );
      case 3:
        return FutureBuilder(
          future: _exchangesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColors.appColor,
              ));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final exchanges = snapshot.data!;
              return ListView.builder(
                itemCount: exchanges.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(exchanges[index]['name']),
                    subtitle: Text(exchanges[index]['country']),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        );
      case 4:
        return Center(child: Text('Categories Coming Soon'));
      default:
        return SizedBox();
    }
  }

  RefreshIndicator coinsList() {
    return RefreshIndicator(
      onRefresh: _refreshCoins,
      color: AppColors.appColor,
      child: FutureBuilder<List<CoinModel>>(
        future: _coinsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.appColor,
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final coins = snapshot.data!;

            return Column(
              children: [
                // Header Row
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
                          '#',
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
                          'Market Cap',
                          style: TextStyle(
                            color: AppColors.inactiveIcon,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Price',
                            style: TextStyle(
                              color: AppColors.inactiveIcon,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '24h %',
                          style: TextStyle(
                            color: AppColors.inactiveIcon,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 60.sp,
                          child: Text(
                            textAlign: TextAlign.center,
                            '7d',
                            style: TextStyle(
                              color: AppColors.inactiveIcon,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // List Items
                Expanded(
                  child: ListView.builder(
                    itemCount: coins.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final upTrend = coins[index].priceChangePercentage24h > 0;
                      final chartColor = upTrend
                          ? AppColors.chartUpTrend
                          : AppColors.chartDownTrend;
                      return GestureDetector(
                        onTap: () {
                          context.push('/coinDetails', extra: coins[index]);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.sp, vertical: 8.sp),
                          child: SizedBox(
                            height: 50.sp,
                            child: Row(
                              spacing: 7.sp,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(coins[index].marketCapRank.toString()),
                                SizedBox(),
                                Image.network(
                                  coins[index].image,
                                  height: 26.sp,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formatSymbol(
                                          coins[index].symbol.toUpperCase()),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      formatMarketCap(
                                          coins[index].marketCap.toDouble()),
                                      style: TextStyle(
                                        color: AppColors.inactiveIcon,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.end,
                                    formatPrice(
                                        coins[index].currentPrice.toDouble()),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${coins[index].priceChangePercentage24h.toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: upTrend
                                            ? AppColors.chartUpTrend
                                            : AppColors.chartDownTrend,
                                      ),
                                    ),
                                    Icon(
                                      upTrend
                                          ? LucideIcons.arrowUp
                                          : LucideIcons.arrowDown,
                                      size: 12.sp,
                                      color: upTrend
                                          ? AppColors.chartUpTrend
                                          : AppColors.chartDownTrend,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25.sp,
                                  width: 60.sp,
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
                                    fillColor:
                                        chartColor.withValues(alpha: 0.1),
                                    fillMode: FillMode.below,
                                    data: List<double>.from(
                                      coins[index]
                                          .sparklineIn7d
                                          .price
                                          .map((e) => e.toDouble()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
