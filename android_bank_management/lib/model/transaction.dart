class Transaction {
  final int id;
  final String description;
  final double amount;
  final String date;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      date: json['date'],
    );
  }
}
