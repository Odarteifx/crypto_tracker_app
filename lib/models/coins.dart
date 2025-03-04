import 'dart:convert';

class Coin {
  final String name;
  final String symbol;
  final double price;
  final double percentageChange;
  Coin({
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentageChange,
  });

  Coin copyWith({
    String? name,
    String? symbol,
    double? price,
    double? percentageChange,
  }) {
    return Coin(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      percentageChange: percentageChange ?? this.percentageChange,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'symbol': symbol,
      'price': price,
      'percentageChange': percentageChange,
    };
  }

  factory Coin.fromMap(Map<String, dynamic> map) {
    return Coin(
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      price: map['price'] as double,
      percentageChange: map['percentageChange'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Coin.fromJson(String source) =>
      Coin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Coin(name: $name, symbol: $symbol, price: $price, percentageChange: $percentageChange)';
  }

  @override
  bool operator ==(covariant Coin other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.symbol == symbol &&
        other.price == price &&
        other.percentageChange == percentageChange;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        symbol.hashCode ^
        price.hashCode ^
        percentageChange.hashCode;
  }
}
