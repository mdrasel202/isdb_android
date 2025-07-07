import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/bankAccountRequest.dart';
import '../model/bankAccountResponce.dart';

class BankAccountService {
  static const String baseUrl = 'http://10.0.2.2:8081'; // emulator IP

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<bool> requestBankAccount(BankAccountRequest request) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/bank/request'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<List<BankAccountResponse>> getAllAccounts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/bank/getAll'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => BankAccountResponse.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load accounts");
    }
  }

  Future<List<BankAccountResponse>> getRequestedAccounts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/bank/requests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => BankAccountResponse.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load requests");
    }
  }

  Future<bool> approveAccount(int id) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/bank/approve/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}