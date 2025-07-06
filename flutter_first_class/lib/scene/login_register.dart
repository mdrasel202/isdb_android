import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_class/scene/registration.dart';

import '../service/auth_service.dart';
import 'login.dart';

class AuthScreen extends StatefulWidget {
  final AuthService authService;
  const AuthScreen({super.key, required this.authService});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLogin = true; // Toggle between login and register

  void _toggleAuthMode() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showLogin ? 'Login' : 'Register'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _showLogin
                        ? LoginForm(
                      key: const ValueKey('LoginForm'),
                      authService: widget.authService,
                      onToggleAuthMode: _toggleAuthMode,
                    )
                        : RegistrationForm(
                      key: const ValueKey('RegistrationForm'),
                      authService: widget.authService,
                      onToggleAuthMode: _toggleAuthMode,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}