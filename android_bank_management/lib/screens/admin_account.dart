import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/bank_account_response.dart';
import '../service/bank_account_api-service.dart';

class AdminAccountPage extends StatefulWidget {
  const AdminAccountPage({super.key});

  @override
  State<AdminAccountPage> createState() => _AdminAccountPageState();
}

class _AdminAccountPageState extends State<AdminAccountPage> {
  final ApiService apiService = ApiService();
  late Future<List<BankAccountResponseDTO>> accountsFuture;
  bool loadingApprove = false;

  @override
  void initState() {
    super.initState();
    accountsFuture = apiService.getAllAccounts();
  }

  void _approveAccount(int id) async {
    setState(() => loadingApprove = true);
    try {
      await apiService.approveAccount(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account approved successfully!')),
      );
      setState(() {
        accountsFuture = apiService.getAllAccounts();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving account: $e')),
      );
    } finally {
      setState(() => loadingApprove = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin: Approve Bank Accounts")),
      body: FutureBuilder<List<BankAccountResponseDTO>>(
        future: accountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No accounts found"));
          }

          final accounts = snapshot.data!;
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Account #: ${account.accountNumber}"),
                  subtitle: Text(
                      "User: ${account.userName}\nStatus: ${account.status}\nBalance: \$${account.availableBalance}"),
                  trailing: account.status == 'PENDING'
                      ? ElevatedButton(
                    onPressed: loadingApprove
                        ? null
                        : () => _approveAccount(account.id),
                    child: loadingApprove
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Text("Approve"),
                  )
                      : const Text("Approved"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}