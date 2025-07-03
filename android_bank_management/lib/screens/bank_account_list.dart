import 'package:flutter/material.dart';
import '../model/bank_account_response.dart';
import '../service/bank_account_api-service.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  late Future<List<BankAccountResponseDTO>> _accounts;

  @override
  void initState() {
    super.initState();
    _accounts = ApiService().getAllAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Bank Accounts")),
      body: FutureBuilder<List<BankAccountResponseDTO>>(
        future: _accounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final accounts = snapshot.data!;
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final acc = accounts[index];
              return ListTile(
                title: Text('${acc.userName} (${acc.accountNumber})'),
                subtitle: Text('Type: ${acc.type.name}, Balance: \$${acc.availableBalance}'),
              );
            },
          );
        },
      ),
    );
  }
}