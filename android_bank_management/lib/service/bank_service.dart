import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/bank_account.dart';

class BankService {
  static const String baseUrl = "http://10.0.2.2:8081/bank";

  static Future<void> createAccount({
    required int userId,
    required String name,
    required String type,
    required double balance,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/request"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "type": type,
        "balance": balance,
        "requestDate": DateTime.now().toIso8601String(),
        "userId": userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to create account: ${response.body}");
    }
  }

  static Future<List<BankAccount>> fetchAccounts() async {
    final response = await http.get(Uri.parse("$baseUrl/getAll"));

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => BankAccount.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch accounts: ${response.body}");
    }
  }
}