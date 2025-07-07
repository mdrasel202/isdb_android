import '../enum/accountType.dart';

class BankAccountResponse {
  final int id;
  final String accountNumber;
  final int userId;
  final String userName;
  final AccountType type;
  final AccountStatus status;
  final double availableBalance;
  final String openedDate;

  BankAccountResponse({
    required this.id,
    required this.accountNumber,
    required this.userId,
    required this.userName,
    required this.type,
    required this.status,
    required this.availableBalance,
    required this.openedDate,
  });

  factory BankAccountResponse.fromJson(Map<String, dynamic> json) {
    return BankAccountResponse(
      id: json['id'],
      accountNumber: json['accountNumber'],
      userId: json['userId'],
      userName: json['userName'],
      type: AccountType.values.byName(json['type']),
      status: AccountStatus.values.byName(json['status']),
      availableBalance: (json['availableBalance'] as num).toDouble(),
      openedDate: json['openedDate'],
    );
  }
}
