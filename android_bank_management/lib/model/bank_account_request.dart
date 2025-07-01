class BankAccountRequest {
  final int userId;
  final String type;
  final String name;
  final double balance;
  final String requestDate;

  BankAccountRequest({
    required this.userId,
    required this.type,
    required this.name,
    required this.balance,
    required this.requestDate,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'type': type,
    'name': name,
    'balance': balance,
    'requestDate': requestDate,
  };
}
