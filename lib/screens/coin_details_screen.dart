import 'dart:convert';

import 'package:crypto_tracker_app/constants/colors.dart';
import 'package:crypto_tracker_app/models/coins.dart';
import 'package:crypto_tracker_app/models/coins_detailed.dart';
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
  Map<String, dynamic>? coinDetails;
 
  Future<Map<String, dynamic>?> getCoinDetails() async {
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url = 'https://api.coingecko.com/api/v3/coins/${widget.coin.id}';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: {'x-cg-demo-api-key': apiKey, 'accept': 'application/json'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // final CoinDetailed data = CoinDetailed.fromJson(jsonData);
        setState(() {
          coinDetails = jsonData;
        });
        // debugPrint(jsonData.toString());

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
    getCoinDetails();
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
            Text(coinDetails!.entries.first.value.toString())
          ],
        ),
      ),
    );
  }
}
