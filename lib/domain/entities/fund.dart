class Fund {
  final int id;
  final String name;
  final double minAmount;
  final String category;
  final double? investedAmount;

  Fund({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.category,
    this.investedAmount,
  });
}
