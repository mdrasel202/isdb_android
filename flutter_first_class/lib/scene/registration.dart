import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enum/role.dart';
import '../model/registerRequest.dart';
import '../service/auth_service.dart';

class RegistrationForm extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onToggleAuthMode;

  const RegistrationForm({
    super.key,
    required this.authService,
    required this.onToggleAuthMode,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Role? _selectedRole = Role.USER; // Default role
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final request = RegisterRequest(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          role: _selectedRole!,
        );
        await widget.authService.registerUser(request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! You can now log in.'),
            backgroundColor: Colors.green,
          ),
        );
        // Optionally switch to login form after successful registration
        widget.onToggleAuthMode();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
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
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
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
                return 'Please enter a password';
              }
              if (value.length < 5) {
                return 'Password must be at least 5 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Role>(
            value: _selectedRole,
            decoration: const InputDecoration(
              labelText: 'Role',
              prefixIcon: Icon(Icons.security),
            ),
            onChanged: (Role? newValue) {
              setState(() {
                _selectedRole = newValue;
              });
            },
            items: Role.values.map((Role role) {
              return DropdownMenuItem<Role>(
                value: role,
                child: Text(role.toString().split('.').last),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _submitRegistration,
            child: const Text('Register'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.onToggleAuthMode,
            child: const Text(
              'Already have an account? Login here.',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}