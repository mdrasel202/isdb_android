import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/bank_account.dart';
import '../model/bank_deposit_request.dart';
import '../service/bank_deposit_service.dart';


class DepositFormScreen extends StatefulWidget {
  @override
  _DepositFormScreenState createState() => _DepositFormScreenState();
}

class _DepositFormScreenState extends State<DepositFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  List<BankAccount> _accounts = [];
  BankAccount? _selectedAccount;
  String _result = '';
  bool _loadingAccounts = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await ApiDeposit.getAllAccounts();
      setState(() {
        _accounts = accounts;
        _selectedAccount = accounts.isNotEmpty ? accounts[0] : null;
        _loadingAccounts = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Failed to load accounts: $e';
        _loadingAccounts = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedAccount != null) {
      final request = BankDepositRequestDTO(
        accountNumber: _selectedAccount!.accountNumber,
        depositAmount: double.parse(_amountController.text),
        bankDepositStatus: 'SUCCESS',
      );

      final response = await ApiDeposit.createDeposit(request);

      setState(() {
        _result = response != null
            ? 'Deposit Success!\nID: ${response.id}\nDate: ${response.depositDate}'
            : 'Deposit Failed.';
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Make Deposit')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _loadingAccounts
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<BankAccount>(
                    value: _selectedAccount,
                    items: _accounts.map((account) {
                      return DropdownMenuItem(
                        value: account,
                        child: Text(account.accountNumber),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAccount = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Select Account'),
                    validator: (value) =>
                    value == null ? 'Select an account' : null,
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Deposit Amount'),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Enter amount' : null,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(onPressed: _submit, child: Text('Submit')),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 16, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}