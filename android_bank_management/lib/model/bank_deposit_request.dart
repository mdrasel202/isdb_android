class BankDepositRequestDTO {
  final String accountNumber;
  final double depositAmount;
  final String bankDepositStatus;

  BankDepositRequestDTO({
    required this.accountNumber,
    required this.depositAmount,
    required this.bankDepositStatus,
  });

  Map<String, dynamic> toJson() => {
    'accountNumber': accountNumber,
    'depositAmount': depositAmount,
    'bankDepositStatus': bankDepositStatus,
  };
}
