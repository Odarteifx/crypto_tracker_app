import 'package:crypto_tracker_app/models/coins.dart';
import 'package:crypto_tracker_app/providers/coin_provider.dart';
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
  String inputAmountString = '';
  double inputAmount = 0;
  double outputAmount = 0;

  String formatPrice(price) {
    if (price < 1) {
      return '$price';
    }
    final NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");
    return numberFormat.format(price);
  }

  @override
  void initState() {
    _coinsFuture = ref.read(coinProvider.notifier).fetchCoins();
    super.initState();
  }

  void _swapCoins() {
    setState(() {
      final tempCoin = selectedCoin;
      final tempCoinName = selectedCoinName;

      selectedCoin = outputCoin;
      selectedCoinName = outputCoinName;

      outputCoin = tempCoin;
      outputCoinName = tempCoinName;

      _calculateOutput(inputAmount);
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
            Stack(
              children: [
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
                                        selectedCoin, selectedCoinName, true);
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
                            Text(
                                inputAmountString.isEmpty
                                    ? '0.00'
                                    : inputAmountString,
                                style: TextStyle(fontSize: 25.sp))
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
                                    return coinOption(
                                        outputCoin, outputCoinName, false);
                                  },
                                );
                              },
                              child: Row(
                                spacing: 10.sp,
                                children: [
                                  outputCoin == null
                                      ? ShadAvatar('src',
                                          backgroundColor:
                                              AppColors.backgroundColor)
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
                            Text(
                                outputAmount == 0
                                    ? '0.00'
                                    : formatPrice(outputAmount),
                                style: TextStyle(fontSize: 25.sp))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 86.sp,
                  left: 38.sp,
                  child: ShadIconButton.ghost(
                    width: 30.sp,
                    height: 40.sp,
                    onPressed: _swapCoins,
                    icon: Icon(
                      LucideIcons.arrowDownUp,
                      size: 30.sp,
                      color: AppColors.appColor,
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
                        onTap: (value) => updateInputAmount(value),
                      ),
                      CustomCalcButtn(
                        num: 2,
                        onTap: (value) => updateInputAmount(value),
                      ),
                      CustomCalcButtn(
                        num: 3,
                        onTap: (value) => updateInputAmount(value),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomCalcButtn(
                        num: 4,
                        onTap: (value) => updateInputAmount(value),
                      ),
                      CustomCalcButtn(
                        num: 5,
                        onTap: (value) => updateInputAmount(value),
                      ),
                      CustomCalcButtn(
                        num: 6,
                        onTap: (value) => updateInputAmount(value),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomCalcButtn(
                        num: 7,
                        onTap: (value) => updateInputAmount(value),
                      ),
                      CustomCalcButtn(
                        num: 8,
                        onTap: (value) => updateInputAmount(value),
                      ),
                      CustomCalcButtn(
                        num: 9,
                        onTap: (value) => updateInputAmount(value),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomCalcButtn(
                        num: '.',
                        onTap: (value) => updateInputAmount(value),
                      ),
                      CustomCalcButtn(
                        num: 0,
                        onTap: (value) => updateInputAmount(value),
                      ),
                      CustomCalcButtn(
                          num: '<', onTap: (value) => updateInputAmount(value))
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

  ShadSheet coinOption(CoinModel? coinentry, String name, bool isInput) {
    return ShadSheet(
      backgroundColor: AppColors.backgroundColor,
      title: Text('Select Coin'),
      child: SizedBox(
        height: 600.sp,
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
                                  if (isInput) {
                                    selectedCoin = coin[index];
                                    selectedCoinName = coin[index].name;
                                  } else {
                                    outputCoin = coin[index];
                                    outputCoinName = coin[index].name;
                                  }
                                  _calculateOutput(inputAmount);
                                });
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Expanded(
                                  child: Row(
                                    children: [
                                      Image.network(
                                        coin[index].image,
                                        height: 26.sp,
                                      ),
                                      SizedBox(width: 8.sp),
                                      Flexible(child: Text(coin[index].name,overflow: TextOverflow.ellipsis,)),
                                    ],
                                  ),
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

  void updateInputAmount(dynamic value) {
    setState(() {
      if (value == '<') {
        if (inputAmountString.isNotEmpty) {
          inputAmountString =
              inputAmountString.substring(0, inputAmountString.length - 1);
        }
      } else if (value == '.') {
        if (!inputAmountString.contains('.')) {
          inputAmountString += value.toString();
        }
      } else {
        inputAmountString += value.toString();
      }

      // Parse the input string to a double
      inputAmount = double.tryParse(inputAmountString) ?? 0;
      _calculateOutput(inputAmount);
    });
  }

  void _calculateOutput(double input) {
    if (selectedCoin != null && outputCoin != null) {
      final result = input * (selectedCoin!.currentPrice / outputCoin!.currentPrice);

      setState(() {
        if (result < 1 ) {
          outputAmount = double.parse(result.toStringAsFixed(8));
        } else {
          outputAmount = result;
        }
      });
    }
  }
}

class CustomCalcButtn extends StatelessWidget {
  final dynamic num;
  final Function(dynamic) onTap;
  const CustomCalcButtn({
    super.key,
    required this.num,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      backgroundColor: AppColors.shadowColor,
      decoration: ShadDecoration(
          border: ShadBorder.all(radius: BorderRadius.circular(50))),
      onPressed: () {
        onTap(num);
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
