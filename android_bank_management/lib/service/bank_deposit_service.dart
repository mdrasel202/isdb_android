import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/bank_account.dart';
import '../model/bank_deposit_request.dart';
import '../model/bank_deposit_response.dart';

class ApiDeposit {
  static const String baseUrl = "http://10.0.2.2:8081";
  // static const String baseUrl = 'http://192.168.0.110:8081';

  static Future<BankDepositResponseDTO?> createDeposit(BankDepositRequestDTO request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bankdeposit/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      return BankDepositResponseDTO.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<List<BankAccount>> getAllAccounts() async {
    final response = await http.get(Uri.parse('$baseUrl/bank/getAll'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => BankAccount.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  static Future<List<BankDepositResponseDTO>> getAllDeposits() async {
    final response = await http.get(Uri.parse('$baseUrl/bankdeposit/getAll'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => BankDepositResponseDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load all deposits');
    }
  }

}