import '../../domain/entities/fund.dart';

class FundModel extends Fund {
  FundModel({
    required super.id,
    required super.name,
    required super.minAmount,
    required super.category,
    super.investedAmount,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'] as int,
      name: json['name'] as String,
      minAmount: (json['minAmount'] as num).toDouble(),
      category: json['category'] as String,
      investedAmount: json['investedAmount'] != null 
          ? (json['investedAmount'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'minAmount': minAmount,
      'category': category,
      'investedAmount': investedAmount,
    };
  }
}
