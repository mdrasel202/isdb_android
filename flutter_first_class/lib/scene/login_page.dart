import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/registerRequest.dart';
import '../model/userResponse.dart';
import '../service/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final authService = AuthService(); // Instantiate AuthService here

  bool loading = false;

  void login() async {
    setState(() => loading = true);
    try {
      // Corrected 'User' to 'UserResponse' to match your model definition
      UserResponse? user = await authService.login(emailCtrl.text, passwordCtrl.text);

      // Navigate to HomePage, passing the authenticated user
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage(user: user!)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress, // Added keyboard type for better UX
            ),
            const SizedBox(height: 10), // Added spacing between text fields
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: loading ? const CircularProgressIndicator() : const Text("Login"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Make button wider for better touch target
              ),
            )
          ],
        ),
      ),
    );
  }
}