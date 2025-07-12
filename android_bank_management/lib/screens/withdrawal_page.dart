import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/bank_account.dart';
import '../model/withdrawal_transaction.dart';
import '../service/withdraeal_service.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final WithdrawalService service = WithdrawalService();

  List<BankAccount> accounts = [];
  String? selectedAccountNumber;
  double amount = 0;
  String message = '';
  List<WithdrawalTransaction> withdrawalList = [];

  @override
  void initState() {
    super.initState();
    fetchAccounts();
    fetchWithdrawals();
  }

  Future<void> fetchAccounts() async {
    try {
      final data = await service.fetchAccounts();
      setState(() => accounts = data);
    } catch (e) {
      setState(() => message = 'Error loading accounts: $e');
    }
  }

  Future<void> fetchWithdrawals() async {
    try {
      final data = await service.getAllWithdrawals();
      setState(() => withdrawalList = data);
    } catch (e) {
      setState(() => message = 'Error loading withdrawals: $e');
    }
  }

  Future<void> submitWithdrawal() async {
    if (selectedAccountNumber == null || amount <= 0) {
      setState(() => message = 'Select account and enter valid amount');
      return;
    }

    try {
      final result = await service.withdraw(selectedAccountNumber!, amount);
      setState(() {
        message = result;
        amount = 0;
      });
      fetchWithdrawals();
    } catch (e) {
      setState(() => message = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Withdraw Money")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select Account"),
              value: selectedAccountNumber,
              items: accounts.map((account) {
                return DropdownMenuItem<String>(
                  value: account.accountNumber,
                  child: Text('${account.accountNumber} '), //- ${account.name}
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedAccountNumber = val),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              onChanged: (val) => amount = double.tryParse(val) ?? 0,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitWithdrawal,
              child: const Text("Withdraw"),
            ),
            const SizedBox(height: 10),
            Text(message, style: const TextStyle(color: Colors.green)),
            const Divider(),
            const Text("All Withdrawals", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: withdrawalList.length,
                itemBuilder: (context, index) {
                  final item = withdrawalList[index];
                  return ListTile(
                    title: Text("Account: ${item.accountNumber}"),
                    subtitle: Text("Amount: ${item.amount}, Status: ${item.status}"),
                    trailing: Text(item.timestamp),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
