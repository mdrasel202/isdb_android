import '../constants/bank_account_enum.dart';

class BankAccountRequestDTO {
  final int userId;
  final AccountType type;
  final String name;
  final double balance;
  final String? requestDate;

  BankAccountRequestDTO({
    required this.userId,
    required this.type,
    required this.name,
    required this.balance,
    required this.requestDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type.toString().split('.').last,
      'name': name,
      'balance': balance,
      'requestDate': requestDate ?? DateTime.now().toIso8601String(),
    };
  }
}
