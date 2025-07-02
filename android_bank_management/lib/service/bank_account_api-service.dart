import 'package:android_bank_management/model/bank_account_request.dart';
import 'package:android_bank_management/model/bank_account_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ApiService{
  static const String baseUrl = "http://10.0.2.2:8081/bank";
  // static const String baseUrl = "http://192.168.0.116:8081/bank";

  Future<String> requestBankAccount(BankAccountRequestDTO dto) async {
    final url = Uri.parse('$baseUrl/request');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw Exception(
            'Failed to request bank account: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error requesting bank account: $e');
    }
  }


  Future<List<BankAccountResponseDTO>> getAllAccounts() async {
    final resp = await http.get(Uri.parse('$baseUrl/getAll'));
    if (resp.statusCode == 200) {
      final List list = jsonDecode(resp.body);
      return list.map((e) => BankAccountResponseDTO.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch accounts');

  }
}