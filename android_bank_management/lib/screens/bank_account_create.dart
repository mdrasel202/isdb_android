import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/bank_service.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String type = 'SAVING';
  double balance = 0;
  final int userId = 1; // test user

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await BankService.createAccount(
          userId: userId,
          name: name,
          type: type,
          balance: balance,
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Account created successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
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
            DropdownButtonFormField(
              value: type,
              items: ['SAVING', 'CURRENT']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => type = val!),
              decoration: InputDecoration(labelText: "Type"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text("Submit"),
            )
          ]),
        ),
      ),
    );
  }
}