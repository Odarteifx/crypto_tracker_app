import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


final categoriesProvider = ChangeNotifierProvider<CategoriesProvider>((ref) => CategoriesProvider());

class CategoriesProvider extends ChangeNotifier {
  List categories = [];
  
  Future fetchCategories() async{
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url = 'https://api.coingecko.com/api/v3/coins/categories';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri, headers: {
        'x-cg-demo-api-key': apiKey,
        'accept': 'application/json'
      });
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        categories = jsonData;
        notifyListeners();
        debugPrint('Categories updated');
        return categories;
      } else {
        debugPrint('Failed to load categories: ${response.statusCode}');
        return categories;
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return categories;
    }

  }
}