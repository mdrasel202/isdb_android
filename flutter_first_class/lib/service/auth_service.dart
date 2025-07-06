import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/loginRequest.dart';
import '../model/registerRequest.dart';
import '../model/userResponse.dart';

class AuthService extends ChangeNotifier {
  // IMPORTANT: Replace with your actual backend URL if different
  final String _baseUrl = 'http://localhost:8080/api/auth';
  String? _token;
  UserResponse? _currentUser;

  String? get token => _token;
  UserResponse? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null;

  AuthService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    // In a real app, you might want to validate the token with your backend here
    // For this example, we just load it.
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    _token = token;
    notifyListeners();
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    _token = null;
    _currentUser = null;
    notifyListeners();
  }

  Future<UserResponse> register(RegisterRequest request) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _currentUser = UserResponse.fromJson(responseData);
        notifyListeners();
        print('User registered successfully: ${_currentUser!.email}');
        return _currentUser!;
      } else {
        throw Exception(
            'Failed to register: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  // This is the 'login' method that LoginPage is trying to call.
  // Ensure this method exists in your lib/service/auth_service.dart file.
  Future<UserResponse> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String jwtToken = responseData['access_token'];
        final Map<String, dynamic> userData = responseData['user'];
        _currentUser = UserResponse.fromJson(userData);
        await _saveToken(jwtToken);
        print('User logged in successfully: ${_currentUser!.email}');
        return _currentUser!; // Return the user object
      } else {
        throw Exception(
            'Failed to login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _removeToken();
    print('User logged out.');
  }
}
