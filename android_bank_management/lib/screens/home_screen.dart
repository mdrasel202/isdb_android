

import 'package:android_bank_management/screens/resources_screen.dart';
import 'package:android_bank_management/screens/transfer_list.dart';
import 'package:android_bank_management/screens/transfer_screen.dart';
import 'package:android_bank_management/screens/withdrawal_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bank_account_create.dart';
import 'bank_account_list.dart';
import 'deposit_screen.dart';
import 'deposit_screen_list.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const HomeScreen({super.key, required this.user});

  Future<void> _logout(BuildContext context) async {
    await const FlutterSecureStorage().delete(key: 'access_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      // appBar: AppBar(title: Text('Welcome, ${user['firstName']}')),
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 4,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance, size: 28, color: Colors.white),
            const SizedBox(width: 12),
            const Text(
              'Bank Management',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user['firstName']} ${user['lastName']}',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    user['email'],
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateAccountScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text('List Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  AccountListScreen(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.storage),
            //   title: const Text('Resources'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const ResourcesScreen(),
            //       ),
            //     );
            //   },
            // ),

            ListTile(
              leading: const Icon(Icons.deblur),
              title: const Text('Deposit List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllDepositListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Transfer Amount'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransferScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Transfer List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Withdrawal Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawalPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Home Screen')),
    );
  }
}
