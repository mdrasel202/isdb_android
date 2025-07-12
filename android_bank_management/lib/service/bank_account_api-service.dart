import 'dart:convert';

import 'package:android_bank_management/model/bank_account_request.dart';
import 'package:android_bank_management/model/bank_account_response.dart';
import 'package:http/http.dart' as http;

import '../model/bank_account.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8081/bank";
  // static const String baseUrl = 'http://192.168.0.110:8081/bank';

  Future<String> requestBankAccount(BankAccountRequestDTO dto) async {
    try {
      final url = Uri.parse('$baseUrl/request');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        // Get more detailed error information
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ?? errorBody['error'] ?? response.body;
        throw Exception(
          'Failed to request account ($response.statusCode): $errorMessage',
        );
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<List<BankAccountResponseDTO>> getAllAccounts() async {
    final response = await http.get(Uri.parse('$baseUrl/getAll'));
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => BankAccountResponseDTO.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch accounts');
    }
  }

  //admin
  // Approve account by ID (POST)
  Future<BankAccountResponseDTO> approveAccount(int accountId) async {
    final url = Uri.parse('$baseUrl/approve/$accountId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return BankAccountResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to approve account');
    }
  }
}
