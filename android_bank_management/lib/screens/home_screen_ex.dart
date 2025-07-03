import 'package:flutter/material.dart';

import 'bank_account_create.dart';
import 'bank_account_list.dart';

class HomeScreenEx extends StatelessWidget {
  const HomeScreenEx({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Manu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.account_balance),
            //   title: const Text('Account'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.account_balance),
            //   title: const Text('List Account'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const AccountListScreen()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
