import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/userResponse.dart';

class HomePage extends StatelessWidget {
  // Changed 'User' to 'UserResponse' to match your model definition
  final UserResponse user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, ${user.firstName} ${user.lastName}"),
            const SizedBox(height: 10),
            Text("Email: ${user.email}"),
            // Corrected how role is displayed as it's an enum
            Text("Role: ${user.role.toString().split('.').last}"),
            // Removed the line referencing user.token as UserResponse does not have a token field.
            // The token is managed by AuthService. If you need to display the token,
            // you would need to pass it separately or access it via AuthService.
          ],
        ),
      ),
    );
  }
}