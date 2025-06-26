import 'dart:convert';
import 'dart:io';

import 'package:empoyee_crud/models/online_employee.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiService{
  static const String baseUrl = 'http://10.0.2.2:8080';

  Future<List<OnlineEmployee>> getAllEmployees() async{
    final response = await http.get(Uri.parse('$baseUrl/employee'));
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => OnlineEmployee.fromJson(json)).toList();
    }else{
      throw Exception('Failed to load employees');
    }
  }

  Future<OnlineEmployee> getEmployeeById(int id) async{
    final response = await http.get(Uri.parse('$baseUrl/employee/$id'));
    if(response.statusCode == 200){
      return OnlineEmployee.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load employye');
    }
  }

  Future<OnlineEmployee> saveEmployee(OnlineEmployee employee) async{
    final response = await http.post(
      Uri.parse('$baseUrl/employee'),
      headers: {'Content-Type' : 'application/json'},
      body: jsonEncode(employee.toJson()),
    );
    if(response.statusCode == 200){
      return OnlineEmployee.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to save employee');
    }
  }

  Future<OnlineEmployee> updateEmployee(int id, OnlineEmployee employee) async{
    final response = await http.put(
      Uri.parse('$baseUrl/employee/$id'),
      headers: {'Content-Type' : 'application/json'},
      body: jsonEncode(employee.toJson()),
    );
    if(response.statusCode == 200){
      return OnlineEmployee.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to save employee');
    }
  }

  Future<void> deleteEmployee(int id) async{
    final response = await http.delete(Uri.parse('$baseUrl/employee/$id'));
    if(response.statusCode != 200){
      throw Exception('Failed to delete employee');
    }
  }
}