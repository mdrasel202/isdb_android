import '../constants/bank_account_enum.dart';

class BankAccountRequestDTO {
  final AccountType type;
  final String name;
  final double? balance;
  final String requestDate;
  final int userId;

  BankAccountRequestDTO({
    required this.type,
    required this.name,
    this.balance,
    required this.requestDate,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'name': name,
      'balance': balance,
      'requestDate': requestDate,
      'userId': userId,
    };
  }
}