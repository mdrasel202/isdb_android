import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/bank_account.dart';
import '../model/withdrawal_transaction.dart';

class WithdrawalService {
  static const String baseUrl = "http://10.0.2.2:8081"; // Android emulator to localhost

  // ✅ Get bank accounts
  Future<List<BankAccount>> fetchAccounts() async {
    final response = await http.get(Uri.parse('$baseUrl/bank/getAll'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => BankAccount.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  // ✅ Withdraw money
  Future<String> withdraw(String accountNumber, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/withdrawal'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'accountNumber': accountNumber, 'amount': amount}),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Withdrawal failed');
    }
  }

  // ✅ Get all withdrawal transactions
  Future<List<WithdrawalTransaction>> getAllWithdrawals() async {
    final response = await http.get(Uri.parse('$baseUrl/withdrawal/admin'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => WithdrawalTransaction.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load withdrawal list');
    }
  }
}
