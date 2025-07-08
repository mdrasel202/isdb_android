class TransferRequestDTO {
  final String fromAccountNumber;
  final String toAccountNumber;
  final double amount;

  TransferRequestDTO({
    required this.fromAccountNumber,
    required this.toAccountNumber,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromAccountNumber': fromAccountNumber,
      'toAccountNumber': toAccountNumber,
      'amount': amount,
    };
  }
}
