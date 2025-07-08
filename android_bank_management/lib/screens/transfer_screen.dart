import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/bank_account.dart';
import '../model/transfer_request.dart';
import '../service/transfer_service.dart';

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  List<BankAccount> accounts = [];
  BankAccount? fromAccount;
  BankAccount? toAccount;

  final _amountController = TextEditingController();
  String _result = '';

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    try {
      List<BankAccount> fetchedAccounts = await ApiTransfer.getAccounts(); // Your API call here
      setState(() {
        accounts = fetchedAccounts;
        if (accounts.isNotEmpty) {
          fromAccount = accounts[0];
          toAccount = accounts.length > 1 ? accounts[1] : accounts[0];
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Failed to load accounts: $e';
      });
    }
  }

  Future<void> _submitTransfer() async {
    if (fromAccount == null || toAccount == null) {
      setState(() => _result = 'Select both From and To accounts');
      return;
    }
    try {
      final request = TransferRequestDTO(
        fromAccountNumber: fromAccount!.accountNumber,
        toAccountNumber: toAccount!.accountNumber,
        amount: double.parse(_amountController.text),
      );

      final result = await ApiTransfer.makeTransfer(request);
      setState(() => _result = result);
    } catch (e) {
      setState(() => _result = 'Transfer failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transfer Money')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<BankAccount>(
              value: fromAccount,
              hint: Text('Select From Account'),
              isExpanded: true,
              items: accounts.map((account) {
                return DropdownMenuItem(
                  value: account,
                  child: Text('${account.accountNumber} (${account.name ?? 'No Name'})'),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  fromAccount = val;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<BankAccount>(
              value: toAccount,
              hint: Text('Select To Account'),
              isExpanded: true,
              items: accounts.map((account) {
                return DropdownMenuItem(
                  value: account,
                  child: Text('${account.accountNumber} (${account.name ?? 'No Name'})'),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  toAccount = val;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitTransfer,
              child: Text('Submit Transfer'),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}