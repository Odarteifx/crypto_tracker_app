import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_tracker_app/constants/assets.dart';
import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/models/coins.dart';
import 'package:crypto_tracker_app/providers/categories_provider.dart';
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
  Future? _categoriesFuture;

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

  String formatCatCap(double price) {
    if (price < 1) {
      return '\$$price';
    }
    final NumberFormat numberFormat = NumberFormat("#,##0", "en_US");
    return '\$${numberFormat.format(price)}';
  }

  String formatSymbol(String symbol) {
    if (symbol.length > 7) {
      return '${symbol.substring(0, 7)}...';
    }
    return symbol;
  }

  Color getTrustColor(trust) {
    if (trust == 10) {
      return AppColors.chartUpTrend;
    } else if (trust < 10 && trust > 5) {
      return Colors.lightGreen;
    } else if (trust <= 5 && trust > 0) {
      return AppColors.chartDownTrend;
    } else {
      return AppColors.chartDownTrend;
    }
  }

  Color getTrustBackgroundColor(trust) {
    if (trust == 10) {
      return AppColors.chartUpTrend.withValues(alpha: 0.1);
    } else if (trust < 10 && trust > 5) {
      return Colors.lightGreen.withValues(alpha: 0.1);
    } else if (trust <= 5 && trust > 0) {
      return AppColors.chartDownTrend.withValues(alpha: 0.1);
    } else {
      return AppColors.chartDownTrend.withValues(alpha: 0.1);
    }
  }

  convertBtcToUsdt(double btcAmount) {
    final btcprice = ref
        .read(coinProvider.notifier)
        .coinMarkets
        .firstWhere((coin) => coin.symbol == 'btc')
        .currentPrice;
    final conPrice = btcprice * btcAmount;

    return formatPrice(conPrice);
  }

  updateNFT() {
    _nftFuture = ref.read(nftProvider.notifier).fetchNFTs();
  }

  updateExchanges() {
    _exchangesFuture = ref.read(exchangesProvider.notifier).fetchExchanges();
  }

  updateCategories() {
    _categoriesFuture = ref.read(categoriesProvider.notifier).fetchCategories();
  }

  Future<void> _refreshCoins() async {
    setState(() {
      _coinsFuture = ref.read(coinProvider.notifier).fetchCoins();
      Future.delayed(Duration(seconds: 10), () {
      updateCategories();
    });
    Future.delayed(Duration(seconds: 30), () {
      updateExchanges();
    });
    Future.delayed(Duration(seconds: 40), () {
      updateNFT();
    });
    });
  }

  @override
  void initState() {
    super.initState();
    _coinsFuture = ref.read(coinProvider.notifier).fetchCoins();
    Future.delayed(Duration(seconds: 10), () {
      updateCategories();
    });
    Future.delayed(Duration(seconds: 30), () {
      updateExchanges();
    });
    Future.delayed(Duration(seconds: 40), () {
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
                    title: Text(nfts[index]['name'] ?? 'No name available'),
                    subtitle: Text(nfts[index]['id'] ?? 'No ID available'),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        );
      case 3:
        return exchangesView();
      case 4:
        return FutureBuilder(
          future: _categoriesFuture,
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
              final categories = snapshot.data!;
              return Column(
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
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final catPercent =
                            categories[index]['market_cap_change_24h'] ?? '--';
                        final upTrend =
                            catPercent == '--' ? catPercent == '0' : catPercent > 0;
                    
                        return GestureDetector(
                          onTap: (){
                            context.push('/categoryDetails',
                                extra: categories[index]);
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
                            child: SizedBox(
                              height: 50.sp,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 5.sp,
                                children: [
                                  SizedBox(
                                    width: 80.sp,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: List.generate(
                                        categories[index]['top_3_coins'].length,
                                        (i) => Positioned(
                                          left: i * 20.sp,
                                          child: ShadAvatar(
                                            categories[index]['top_3_coins'][i],
                                            size: Size(24.sp, 24.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 90.sp,
                                    child: Text(
                                      categories[index]['name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    catPercent == '--'
                                        ? '--'
                                        : '${catPercent.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: upTrend
                                          ? AppColors.chartUpTrend
                                          : AppColors.chartDownTrend,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      categories[index]['market_cap'] == null
                                          ? '--'
                                          : formatCatCap(
                                              categories[index]['market_cap'], ),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
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
        );
      default:
        return SizedBox();
    }
  }

  FutureBuilder<dynamic> exchangesView() {
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
          return Column(
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
                        'Exchange',
                        style: TextStyle(
                          color: AppColors.inactiveIcon,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          'Reported Volume',
                          style: TextStyle(
                            color: AppColors.inactiveIcon,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Trust',
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
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: exchanges.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.sp, vertical: 8.sp),
                            child: SizedBox(
                              height: 50.sp,
                              child: Row(
                                spacing: 7.sp,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(exchanges[index]['trust_score_rank']
                                      .toString()),
                                  SizedBox(),
                                  Image.network(
                                    exchanges[index]['image'],
                                    height: 26.sp,
                                  ),
                                  SizedBox(
                                    width: 85.sp,
                                    child: Text(
                                      exchanges[index]['name'],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      textAlign: TextAlign.start,
                                      convertBtcToUsdt(exchanges[index]
                                          ['trade_volume_24h_btc']),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.iconColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20.sp,
                                    width: 35.sp,
                                    decoration: BoxDecoration(
                                      color: getTrustBackgroundColor(
                                          exchanges[index]['trust_score']),
                                      borderRadius: BorderRadius.circular(5.sp),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${exchanges[index]['trust_score']}/10'
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: getTrustColor(
                                              exchanges[index]['trust_score']),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
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
    );
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
