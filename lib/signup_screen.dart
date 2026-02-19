import 'package:flutter/material.dart';
import 'package:responsive_design/auth_class.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool isLoading = false;
  bool passHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // LAB 4 REQUIREMENT: Password Validator
  // Must be >= 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 symbol
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    // Regex for: at least one upper, one lower, one digit, and one special character
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    
    if (!passwordRegex.hasMatch(value)) {
      return 'Must include: Upper, Lower, Digit, and Symbol (@\$!%*?&)';
    }
    return null;
  }

  void _submitSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await _authService.signUp(email: email, password: password);
      
      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please login.')),
        );
        // LAB 4 REQUIREMENT: Go to login screen on success
        Navigator.pop(context); 
      }
    } catch (e) {
      // LAB 4 REQUIREMENT: Handle existing accounts
      if (e.toString().contains('exists')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account already exists. Redirecting to login...'),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.pop(context); // Move to login screen
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: passHidden,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(passHidden ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => passHidden = !passHidden),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 30),
                
                isLoading 
                  ? const CircularProgressIndicator() 
                  : ElevatedButton(
                      onPressed: _submitSignUp,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                      child: const Text('Create Account'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}