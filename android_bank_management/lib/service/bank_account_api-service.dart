import 'package:android_bank_management/model/bank_account_request.dart';
import 'package:android_bank_management/model/bank_account_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ApiService{
  static const String baseUrl = "http://192.168.0.116/bank";

  Future<String> createAccount(BankAccountRequest req) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body)['message'];
    }
    throw Exception('Create account failed (${resp.statusCode})');
  }

  Future<List<BankAccountResponse>> getAllAccounts() async {
    final resp = await http.get(Uri.parse('$baseUrl/getAll'));
    if (resp.statusCode == 200) {
      final List list = jsonDecode(resp.body);
      return list.map((e) => BankAccountResponse.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch accounts');

  }
}