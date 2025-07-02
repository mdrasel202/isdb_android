import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/bank_account_enum.dart';
import '../model/bank_account_request.dart';
import '../service/bank_account_api-service.dart';

class RequestAccountScreen extends StatefulWidget {
  const RequestAccountScreen({super.key});

  @override
  State<RequestAccountScreen> createState() => _RequestAccountScreenState();
}

class _RequestAccountScreenState extends State<RequestAccountScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  AccountType? _selectedAccountType;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _requestDateController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController(); // New controller for userId

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize request date with today's date
    _requestDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _requestDateController.dispose();
    _userIdController.dispose(); // Dispose the new controller
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final requestDto = BankAccountRequestDTO(
        type: _selectedAccountType!,
        name: _nameController.text,
        balance: double.tryParse(_balanceController.text),
        requestDate: _requestDateController.text,
        userId: int.parse(_userIdController.text), // Parse userId from text
      );

      try {
        final message = await _apiService.requestBankAccount(requestDto);
        _showSnackBar(message, Colors.green);
        _resetForm();
      } catch (e) {
        _showSnackBar('Error: ${e.toString()}', Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _balanceController.clear();
    _selectedAccountType = null;
    _requestDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Reset date
    _userIdController.clear(); // Clear userId
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _requestDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Bank Account'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<AccountType>(
                        value: _selectedAccountType,
                        decoration: InputDecoration(
                          labelText: 'Account Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        hint: const Text('Select Account Type'),
                        items: AccountType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (type) {
                          setState(() {
                            _selectedAccountType = type;
                          });
                        },
                        validator: (value) =>
                        value == null ? 'Please select an account type' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Account Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _balanceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Initial Balance (Optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                            return 'Please enter a valid number for balance';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _requestDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Request Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a request date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _userIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'User ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a User ID';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number for User ID';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Submit Request',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}