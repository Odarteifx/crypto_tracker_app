// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CoinModel {
  final String id;
  final String name;
  final String symbol;
  final String image; 
  final double price;
  final double percentageChange;
  final int marketCap;
  final int marketCapRank;
  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.percentageChange,
    required this.marketCap,
    required this.marketCapRank,
  });
  

  CoinModel copyWith({
    String? id,
    String? name,
    String? symbol,
    String? image,
    double? price,
    double? percentageChange,
    int? marketCap,
    int? marketCapRank,
  }) {
    return CoinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      image: image ?? this.image,
      price: price ?? this.price,
      percentageChange: percentageChange ?? this.percentageChange,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'symbol': symbol,
      'image': image,
      'price': price,
      'percentageChange': percentageChange,
      'marketCap': marketCap,
      'marketCapRank': marketCapRank,
    };
  }

  factory CoinModel.fromMap(Map<String, dynamic> map) {
    return CoinModel(
      id: map['id'] as String,
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      image: map['image'] as String,
      price: map['price'] as double,
      percentageChange: map['percentageChange'] as double,
      marketCap: map['marketCap'] as int,
      marketCapRank: map['marketCapRank'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CoinModel.fromJson(String source) => CoinModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoinModel(id: $id, name: $name, symbol: $symbol, image: $image, price: $price, percentageChange: $percentageChange, marketCap: $marketCap, marketCapRank: $marketCapRank)';
  }

  @override
  bool operator ==(covariant CoinModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.symbol == symbol &&
      other.image == image &&
      other.price == price &&
      other.percentageChange == percentageChange &&
      other.marketCap == marketCap &&
      other.marketCapRank == marketCapRank;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      symbol.hashCode ^
      image.hashCode ^
      price.hashCode ^
      percentageChange.hashCode ^
      marketCap.hashCode ^
      marketCapRank.hashCode;
  }
}
