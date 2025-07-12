import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🛡️ Admin Panel"),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text(
          "This is the Admin Panel UI only (no API)",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}