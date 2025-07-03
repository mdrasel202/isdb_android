import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/bank_account_enum.dart';
import '../model/bank_account_request.dart';
import '../service/bank_account_api-service.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double balance = 0;
  AccountType type = AccountType.SAVING;
  int userId = 0;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? storedId = await const FlutterSecureStorage().read(
        key: 'user_id',
      );
      userId = storedId != null ? int.parse(storedId) : 0;

      final dto = BankAccountRequestDTO(
        userId: userId,
        name: name,
        balance: balance,
        type: type,
        requestDate: DateTime.now().toIso8601String(),
      );

      print('Sending request with data: ${dto.toJson()}');

      try {
        final api = ApiService();
        final message = await api.requestBankAccount(dto);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        Navigator.pop(context);
      } catch (e) {
        print('Error details: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Account")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Account Name"),
                onSaved: (val) => name = val ?? '',
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Initial Balance"),
                keyboardType: TextInputType.number,
                onSaved: (val) => balance = double.parse(val ?? '0'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<AccountType>(
                value: type,
                onChanged: (val) => setState(() => type = val!),
                items: AccountType.values.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e.name));
                }).toList(),
                decoration: InputDecoration(labelText: "Type"),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
