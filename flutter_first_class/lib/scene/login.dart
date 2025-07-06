import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/loginRequest.dart';
import '../service/auth_service.dart';

class LoginForm extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onToggleAuthMode;

  const LoginForm({
    super.key,
    required this.authService,
    required this.onToggleAuthMode,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final request = LoginRequest(
          email: _emailController.text,
          password: _passwordController.text,
        );
        await widget.authService.loginUser(request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _submitLogin,
            child: const Text('Login'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.onToggleAuthMode,
            child: const Text(
              'Don\'t have an account? Register here.',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}