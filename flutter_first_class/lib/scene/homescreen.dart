import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enum/accountType.dart';
import '../model/bankAccountResponce.dart';
import '../service/bankAccountService.dart';

class AllAccountsList extends StatefulWidget {
  final BankAccountService accountService;
  const AllAccountsList({super.key, required this.accountService});

  @override
  State<AllAccountsList> createState() => _AllAccountsListState();
}

class _AllAccountsListState extends State<AllAccountsList> {
  late Future<List<BankAccountResponse>> _allAccountsFuture;

  @override
  void initState() {
    super.initState();
    _allAccountsFuture = widget.accountService.getAllAccounts(); // Fetch all accounts
  }

  Future<void> _refreshAllAccounts() async {
    setState(() {
      _allAccountsFuture = widget.accountService.getAllAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshAllAccounts,
      child: FutureBuilder<List<BankAccountResponse>>(
        future: _allAccountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 60),
                    const SizedBox(height: 10),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _refreshAllAccounts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline,
                      color: Colors.grey, size: 60),
                  const SizedBox(height: 10),
                  const Text(
                    'No bank accounts found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _refreshAllAccounts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final account = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account: ${account.accountNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Divider(height: 16, thickness: 1),
                        _buildInfoRow('User Name:', account.userName),
                        _buildInfoRow('Account Type:',
                            accountTypeToString(account.type)),
                        _buildInfoRow('Status:',
                            accountStatusToString(account.status)),
                        _buildInfoRow('Available Balance:',
                            '\$${account.availableBalance.toStringAsFixed(2)}'),
                        _buildInfoRow('Opened Date:', account.openedDate),
                        _buildInfoRow('User ID:', account.userId.toString()),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
