class BankDepositResponseDTO {
  final int id;
  final String accountNumber;
  final double depositAmount;
  final String bankDepositStatus;
  final String depositDate;

  BankDepositResponseDTO({
    required this.id,
    required this.accountNumber,
    required this.depositAmount,
    required this.bankDepositStatus,
    required this.depositDate,
  });

  factory BankDepositResponseDTO.fromJson(Map<String, dynamic> json) {
    return BankDepositResponseDTO(
      id: json['id'],
      accountNumber: json['accountNumber'],
      depositAmount: (json['depositAmount'] as num).toDouble(),
      bankDepositStatus: json['bankDepositStatus'],
      depositDate: json['depositDate'],
    );
  }
}
