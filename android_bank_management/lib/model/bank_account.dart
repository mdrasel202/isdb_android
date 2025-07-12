// class BankAccount {
//   final int id;
//   final String accountNumber;
//
//   BankAccount({required this.id, required this.accountNumber});
//
//   factory BankAccount.fromJson(Map<String, dynamic> json) {
//     return BankAccount(
//       id: json['id'],
//       accountNumber: json['accountNumber'],
//     );
//   }
// }
class BankAccount {
  final int id;
  final String accountNumber;
  final String? name;
  final double availableBalance;

  BankAccount({
    required this.id,
    required this.accountNumber,
    this.name,
    required this.availableBalance,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'] ?? 0,
      accountNumber: json['accountNumber'] ?? 'No Number',
      name: json['userName'] ?? json['name'] ?? 'Unknown',
      availableBalance: (json['availableBalance'] ?? 0).toDouble(),
    );
  }
}