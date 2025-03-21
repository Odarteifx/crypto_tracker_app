// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NFTModel {
  final String id;
  final String? contractAddress;
  final String name;
  final String assetPlatformId;
  final String symbol;
  NFTModel({
    required this.id,
    required this.contractAddress,
    required this.name,
    required this.assetPlatformId,
    required this.symbol,
  });

  NFTModel copyWith({
    String? id,
    String? contractAddress,
    String? name,
    String? assetPlatformId,
    String? symbol,
  }) {
    return NFTModel(
      id: id ?? this.id,
      contractAddress: contractAddress ?? this.contractAddress,
      name: name ?? this.name,
      assetPlatformId: assetPlatformId ?? this.assetPlatformId,
      symbol: symbol ?? this.symbol,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contractAddress': contractAddress,
      'name': name,
      'assetPlatformId': assetPlatformId,
      'symbol': symbol,
    };
  }

  factory NFTModel.fromMap(Map<String, dynamic> map) {
    return NFTModel(
      id: map['id'] as String,
      contractAddress: map['contract_address'] as String,
      name: map['name'] as String,
      assetPlatformId: map['asset_platform_id'] as String,
      symbol: map['symbol'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTModel.fromJson(String source) =>
      NFTModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NFTModel(id: $id, contractAddress: $contractAddress, name: $name, assetPlatformId: $assetPlatformId, symbol: $symbol)';
  }

  @override
  bool operator ==(covariant NFTModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.contractAddress == contractAddress &&
        other.name == name &&
        other.assetPlatformId == assetPlatformId &&
        other.symbol == symbol;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contractAddress.hashCode ^
        name.hashCode ^
        assetPlatformId.hashCode ^
        symbol.hashCode;
  }
}
