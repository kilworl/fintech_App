enum TransactionType { subscribe, cancel }

class Transaction {
  final String id;
  final TransactionType type;
  final DateTime date;
  final int fundId;
  final String fundName;
  final double amount;

  Transaction({
    required this.id,
    required this.type,
    required this.date,
    required this.fundId,
    required this.fundName,
    required this.amount,
  });
}
