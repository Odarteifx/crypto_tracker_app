// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CoinModel {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final int marketCap;
  final int marketCapRank;
  final SparklineIn7d sparklineIn7d;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.marketCapRank,
    required this.sparklineIn7d,
  });

  CoinModel copyWith({
    String? id,
    String? name,
    String? symbol,
    String? image,
    double? currentPrice,
    double? priceChangePercentage24h,
    int? marketCap,
    int? marketCapRank,
    SparklineIn7d? sparklineIn7d,
  }) {
    return CoinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      sparklineIn7d: sparklineIn7d ?? this.sparklineIn7d,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'symbol': symbol,
      'image': image,
      'currentPrice': currentPrice,
      'priceChangePercentage24h': priceChangePercentage24h,
      'marketCap': marketCap,
      'marketCapRank': marketCapRank,
      'sparklineIn7d': sparklineIn7d.toMap(),
    };
  }

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      image: json['image'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num).toDouble(),
      marketCap: json['market_cap'] as int,
      marketCapRank: json['market_cap_rank'] as int,
      sparklineIn7d: SparklineIn7d.fromJson(json['sparkline_in_7d'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CoinModel(id: $id, name: $name, symbol: $symbol, image: $image, currentPrice: $currentPrice, priceChangePercentage24h: $priceChangePercentage24h, marketCap: $marketCap, marketCapRank: $marketCapRank, sparklineIn7d: $sparklineIn7d)';
  }

  @override
  bool operator ==(covariant CoinModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.symbol == symbol &&
        other.image == image &&
        other.currentPrice == currentPrice &&
        other.priceChangePercentage24h == priceChangePercentage24h &&
        other.marketCap == marketCap &&
        other.marketCapRank == marketCapRank &&
        other.sparklineIn7d == sparklineIn7d;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        symbol.hashCode ^
        image.hashCode ^
        currentPrice.hashCode ^
        priceChangePercentage24h.hashCode ^
        marketCap.hashCode ^
        marketCapRank.hashCode ^
        sparklineIn7d.hashCode;
  }
}

class SparklineIn7d {
  final List<double> price;

  SparklineIn7d({required this.price});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'price': price,
    };
  }

  factory SparklineIn7d.fromJson(Map<String, dynamic> json) {
    return SparklineIn7d(
      price: (json['price'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }
}
