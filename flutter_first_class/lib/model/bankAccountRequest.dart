import '../enum/accountType.dart';

class BankAccountRequest {
  final int userId;
  final AccountType type;
  final String name;
  final double balance;
  final DateTime? requestDate; // required সরিয়ে দিলাম

  BankAccountRequest({
    required this.userId,
    required this.type,
    required this.name,
    required this.balance,
    this.requestDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type.name,
      'name': name,
      'balance': balance,
      'requestDate': requestDate?.toIso8601String(), // null safe
    };
  }
}

