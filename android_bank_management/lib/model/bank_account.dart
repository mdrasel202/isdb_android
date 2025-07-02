class BankAccount {
  final int id;
  final String accountNumber;
  final int userId;
  final String userName;
  final String type;
  final String status;
  final double availableBalance;
  final String? openedDate;

  BankAccount({
    required this.id,
    required this.accountNumber,
    required this.userId,
    required this.userName,
    required this.type,
    required this.status,
    required this.availableBalance,
    this.openedDate,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      accountNumber: json['accountNumber'],
      userId: json['userId'],
      userName: json['userName'],
      type: json['type'],
      status: json['status'],
      availableBalance: (json['availableBalance'] as num).toDouble(),
      openedDate: json['openedDate'],
    );
  }
}