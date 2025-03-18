import 'package:crypto_tracker_app/models/coins.dart';
import 'package:crypto_tracker_app/providers/coin_provider.dart';
import 'package:crypto_tracker_app/screens/coin_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:crypto_tracker_app/constants/colors.dart';

class CoinConverterScreen extends ConsumerStatefulWidget {
  const CoinConverterScreen({super.key});

  @override
  ConsumerState<CoinConverterScreen> createState() =>
      _CoinConverterScreenState();
}

class _CoinConverterScreenState extends ConsumerState<CoinConverterScreen> {
  Future<List<CoinModel>>? _coinsFuture;
  String selectedCoinName = 'Select Coin';
  String outputCoinName = 'Select Coin';
  CoinModel? selectedCoin;
  CoinModel? outputCoin;

  @override
  void initState() {
    _coinsFuture = ref.read(coinProvider.notifier).fetchCoins();
    super.initState();
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
                  SizedBox(
                    width: 70.sp,
                  ),
                  Center(
                    child: Text(
                      'Coin Converter',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              spacing: 10.sp,
              children: [
                SizedBox(
                  height: 100.sp,
                  child: Padding(
                    padding: EdgeInsets.all(20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showShadSheet(
                              context: context,
                              builder: (context) {
                                return coinOption(
                                    selectedCoin, selectedCoinName);
                              },
                            );
                          },
                          child: Row(
                            spacing: 10.sp,
                            children: [
                              selectedCoin == null
                                  ? ShadAvatar('src')
                                  : Image.network(
                                      selectedCoin!.image,
                                      height: 30.sp,
                                    ),
                              Text(
                                selectedCoin == null
                                    ? selectedCoinName
                                    : selectedCoin!.symbol.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        Text('Unit')
                      ],
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
                      children: [
                        GestureDetector(
                          onTap: () {
                            showShadSheet(
                              context: context,
                              builder: (context) {
                                return coinOption(outputCoin, outputCoinName);
                              },
                            );
                          },
                          child: Row(
                            spacing: 10.sp,
                            children: [
                              outputCoin == null
                                  ? ShadAvatar('src', backgroundColor: AppColors.backgroundColor,)
                                  : Image.network(
                                      outputCoin!.image,
                                      height: 30.sp,
                                    ),
                              Text(
                                outputCoin == null
                                    ? outputCoinName
                                    : outputCoin!.symbol.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        Text('Unit')
                      ],
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
                      CustomCalcButtn(
                        num: 1,
                      ),
                      CustomCalcButtn(
                        num: 2,
                      ),
                      CustomCalcButtn(
                        num: 3,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomCalcButtn(
                        num: 4,
                      ),
                      CustomCalcButtn(
                        num: 5,
                      ),
                      CustomCalcButtn(
                        num: 6,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomCalcButtn(
                        num: 7,
                      ),
                      CustomCalcButtn(
                        num: 8,
                      ),
                      CustomCalcButtn(
                        num: 9,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomCalcButtn(
                        num: '.',
                      ),
                      CustomCalcButtn(
                        num: 0,
                      ),
                      CustomCalcButtn(num: '<')
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ShadSheet coinOption(CoinModel? coinentry, String name) {
    return ShadSheet(
      title: Text('Select Coin'),
      child: SizedBox(
        height: 700.sp,
        child: Column(
          children: [
            FutureBuilder(
              future: _coinsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.appColor,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Expanded(
                      child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ));
                } else {
                  final coins = ref.watch(coinProvider);
                  final coin = coins.coinMarkets;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: coin.length,
                      padding: EdgeInsets.all(8.sp),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (coinentry == selectedCoin) {
                                    selectedCoin = coin[index];
                                    selectedCoinName = coin[index].name;
                                  } else {
                                    outputCoin = coin[index];
                                    outputCoinName = coin[index].name;
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.network(
                                      coin[index].image,
                                      height: 26.sp,
                                    ),
                                    SizedBox(width: 8.sp),
                                    Text(coin[index].name),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
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
          border: ShadBorder.all(radius: BorderRadius.circular(50))),
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
