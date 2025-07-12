import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/bank_account.dart';
import '../model/transaction.dart';
import '../model/transfer_request.dart';

class ApiTransfer {
  static const String baseUrl = 'http://10.0.2.2:8081/bank';

  // POST Transfer
  static Future<String> makeTransfer(TransferRequestDTO request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transfer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to make transfer');
    }
  }

  // GET All Transactions
  static Future<List<Transaction>> getAllTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/getAlls'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }

  // GET Transactions for specific account
  static Future<List<Transaction>> getTransactionsByAccount(int accountId) async {
    final response = await http.get(Uri.parse('$baseUrl/$accountId/transactions'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch account transactions');
    }
  }

  static Future<List<BankAccount>> getAccounts() async {
    final response = await http.get(Uri.parse('$baseUrl/getAll'));

    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);
      return jsonList.map((json) => BankAccount.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load accounts');
    }
  }

}