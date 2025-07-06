import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class AuthenticatedHome extends StatelessWidget {
  final AuthService authService;
  const AuthenticatedHome({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are logged in!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (authService.currentUser != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Welcome, ${authService.currentUser!.firstName} ${authService.currentUser!.lastName} (${authService.currentUser!.email})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'This is a placeholder for your main application content.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}