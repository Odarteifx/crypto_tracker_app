import 'dart:convert';
import 'package:crypto_tracker_app/models/coins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinProvider =
    ChangeNotifierProvider<CoinProvider>((ref) => CoinProvider());

class CoinProvider extends ChangeNotifier {
  List<CoinModel> coinMarkets = [];
   List coinChart = [];

  Future<List<CoinModel>> fetchCoins() async {
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&sparkline=true&price_change_percentage=7d';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: {'x_cg_demo_api_key': apiKey, 'accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        coinMarkets = jsonData.map((json) => CoinModel.fromJson(json)).toList();
        notifyListeners();
        debugPrint('Coins updated');
        return coinMarkets;
      } else {
        throw Exception('Failed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching coins: $e');
    }
  }

  Future<Map<String, dynamic>?> getCoinDetails(widget) async {
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url = 'https://api.coingecko.com/api/v3/coins/${widget.coin.id}';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: {'x-cg-demo-api-key': apiKey, 'accept': 'application/json'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final coinDetails = jsonData;
        debugPrint('Coin details updated');
        notifyListeners();
        return coinDetails;
      } else {
        throw Exception('Failed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching coins: $e');
    }
  }

  Future getCoinChart(widget, day, currency) async {
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url =
        'https://api.coingecko.com/api/v3/coins/${widget.coin.id}/ohlc?vs_currency=$currency&days=$day';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: {'x-cg-demo-api-key': apiKey, 'accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        coinChart = jsonData;
        notifyListeners();
        debugPrint('coinChart drawn');
        return coinChart;
      } else {
        debugPrint('Failed to load coins: ${response.statusCode}');
        return coinChart;
      }
    } catch (e) {
      debugPrint(e.toString());
      return coinChart;
    }
  }
}