import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enum/accountType.dart';
import '../model/bankAccountRequest.dart';
import '../model/bankAccountResponce.dart';
import '../service/bankAccountService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  AccountType? selectedType;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  int userId = 1; // TODO: Replace with actual logged-in user ID

  List<BankAccountResponse> requestedAccounts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRequestedAccounts();
  }

  Future<void> fetchRequestedAccounts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final accounts = await BankAccountService().getRequestedAccounts();
      setState(() {
        requestedAccounts = accounts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load requested accounts: \$e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate() && selectedType != null) {
      final request = BankAccountRequest(
        userId: userId,
        type: selectedType!,
        name: _nameController.text,
        balance: double.tryParse(_balanceController.text) ?? 0.0,
      );

      final success = await BankAccountService().requestBankAccount(request);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account requested successfully')),
        );
        _nameController.clear();
        _balanceController.clear();
        fetchRequestedAccounts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to request account')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Account Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<AccountType>(
                    decoration: const InputDecoration(labelText: 'Account Type'),
                    value: selectedType,
                    items: AccountType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(accountTypeToString(type)),
                      );
                    }).toList(),
                    onChanged: (type) => setState(() => selectedType = type),
                    validator: (value) => value == null ? 'Please select type' : null,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Account Name'),
                    validator: (value) => (value == null || value.isEmpty) ? 'Enter name' : null,
                  ),
                  TextFormField(
                    controller: _balanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Initial Balance'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitRequest,
                    child: const Text('Request Account'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Requested Accounts',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: requestedAccounts.length,
                itemBuilder: (context, index) {
                  final account = requestedAccounts[index];
                  return Card(
                    child: ListTile(
                      title: Text('${account.userName} - ${account.accountNumber}'),
                      subtitle: Text(
                        'Type: \${accountTypeToString(account.type)} | '
                            'Status: \${accountStatusToString(account.status)}\n'
                            'Balance: \${account.availableBalance}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}