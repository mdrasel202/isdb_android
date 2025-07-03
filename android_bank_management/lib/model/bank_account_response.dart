import '../constants/bank_account_enum.dart';

class BankAccountResponseDTO {
  final int id;
  final String accountNumber;
  final int userId;
  final String userName;
  final AccountType type;
  final String status;
  final double availableBalance;
  final String openedDate;

  BankAccountResponseDTO({
    required this.id,
    required this.accountNumber,
    required this.userId,
    required this.userName,
    required this.type,
    required this.status,
    required this.availableBalance,
    required this.openedDate,
  });

  factory BankAccountResponseDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountResponseDTO(
      id: json['id'],
      accountNumber: json['accountNumber'],
      userId: json['userId'],
      userName: json['userName'],
      type: AccountType.values.firstWhere((e) => e.name == json['type']),
      status: json['status'],
      availableBalance: (json['availableBalance'] as num).toDouble(),
      openedDate: json['openedDate'],
    );
  }
}