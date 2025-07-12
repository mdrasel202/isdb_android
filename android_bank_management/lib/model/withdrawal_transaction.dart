class WithdrawalTransaction {
  final String accountNumber;
  final double amount;
  final String timestamp;
  final String status;

  WithdrawalTransaction({
    required this.accountNumber,
    required this.amount,
    required this.timestamp,
    required this.status,
  });

  factory WithdrawalTransaction.fromJson(Map<String, dynamic> json) {
    return WithdrawalTransaction(
      accountNumber: json['accountNumber'],
      amount: (json['amount'] ?? 0).toDouble(),
      timestamp: json['timestamp'],
      status: json['status'],
    );
  }
}
