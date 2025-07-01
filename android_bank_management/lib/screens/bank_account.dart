import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/bank_account_request.dart';
import '../service/bank_account_api-service.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});
  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _form = GlobalKey<FormState>();
  final _userId = TextEditingController();
  final _name = TextEditingController();
  final _balance = TextEditingController();
  String _type = 'SAVING';
  final ApiService api = ApiService();

  void submit() async {
    if (_form.currentState!.validate()) {
      final req = BankAccountRequest(
        userId: int.parse(_userId.text.trim()),
        type: _type,
        name: _name.text.trim(),
        balance: double.parse(_balance.text.trim()),
        requestDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      try {
        final msg = await api.createAccount(req);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: const Text('Add Account')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _form,
        child: ListView(children: [
          TextFormField(
            controller: _userId,
            decoration: const InputDecoration(labelText: 'User ID'),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty || int.tryParse(v)==null ? 'Enter valid ID' : null,
          ),
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Account Name'),
            validator: (v) => v!.isEmpty ? 'Enter name' : null,
          ),
          DropdownButtonFormField<String>(
            value: _type,
            items: const [
              DropdownMenuItem(value: 'SAVING', child: Text('SAVING')),
              DropdownMenuItem(value: 'CURRENT', child: Text('CURRENT')),
            ],
            onChanged: (v) => setState(() => _type = v!),
            decoration: const InputDecoration(labelText: 'Type'),
          ),
          TextFormField(
            controller: _balance,
            decoration: const InputDecoration(labelText: 'Initial Balance'),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty || double.tryParse(v)==null ? 'Enter valid number' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: submit, child: const Text('Create')),
        ]),
      ),
    ),
  );
}