import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/nfts.dart';

final nftProvider = ChangeNotifierProvider<NftProvider>((ref) => NftProvider());

class NftProvider extends ChangeNotifier {
  List<NFTModel> nfts = [];

  Future fetchNFTs() async {
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url =
        'https://api.coingecko.com/api/v3/nfts/list?order=h24_volume_usd_desc&per_page=100&page=2';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: {'x-cg-demo-api-key': apiKey, 'accept': 'application/json'});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        nfts = jsonData.map((json) => NFTModel.fromMap(json)).toList();
        debugPrint('nfts updated');
        notifyListeners();
        return nfts;
      } else {
        debugPrint('Failed to load NFTs: ${response.statusCode}');
        return nfts;
      }
    } catch (e) {
      debugPrint(e.toString());
      return nfts;
    }
  }

  Future getNFTDetails(nft) async { //working
    final apiKey = '${dotenv.env['COINGECKO_API_KEY']}';
    String url = 'https://api.coingecko.com/api/v3/nfts/$nft';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: {'x-cg-demo-api-key': apiKey, 'accept': 'application/json'});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final nftDetails = jsonData;
        debugPrint(nftDetails.toString());
        notifyListeners();
        return nftDetails;
      } else {
        debugPrint('Failed to load NFTs: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
