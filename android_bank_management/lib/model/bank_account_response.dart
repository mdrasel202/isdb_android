import '../constants/bank_account_enum.dart';
import '../constants/bank_account_status.dart';

class BankAccountResponseDTO {
  final int id;
  final String accountNumber;
  final int userId;
  final String userName;
  final AccountType type;
  final AccountStatus status;
  final double availableBalance;
  final String openedDate; // Represent LocalDate as String "yyyy-MM-dd"

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
      type: AccountType.values.firstWhere(
              (e) => e.toString().split('.').last == json['type']),
      status: AccountStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['status']),
      availableBalance: json['availableBalance'].toDouble(),
      openedDate: json['openedDate'],
    );
  }
}