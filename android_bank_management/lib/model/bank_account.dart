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
  final String? name;  // nullable name
  final double availableBalance;

  BankAccount({
    required this.id,
    required this.accountNumber,
    this.name,
    required this.availableBalance,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      accountNumber: json['accountNumber'],
      name: json['userName'] ?? 'Unknown',  // or json['name'] depending on your API
      availableBalance: (json['availableBalance'] as num).toDouble(),
    );
  }
}
