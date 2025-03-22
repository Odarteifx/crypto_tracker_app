import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final exhangesProvider = ChangeNotifierProvider<ExchangesProvider>((ref) => ExchangesProvider());

class ExchangesProvider extends ChangeNotifier {
  List exchanges = [];

  Future<List<dynamic>> fetchExchanges() async {
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url =
        'https://api.coingecko.com/api/v3/exchanges?per_page=101&page=1';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: {'x-cg-demo-api-key': apiKey, 'accept': 'application/json'});

          if (response.statusCode == 200) {
            final List<dynamic> jsonData = jsonDecode(response.body);
            exchanges = jsonData;
            notifyListeners();
            debugPrint('Exchanges updated');
            return exchanges;
          } else {
            debugPrint('Failed to load exchanges: ${response.statusCode}');
            return exchanges;
          }
    } catch (e) {
      debugPrint(e.toString());
      return exchanges;
    }
  }
}
