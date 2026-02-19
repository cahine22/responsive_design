import 'package:flutter/material.dart';
import 'package:responsive_design/auth_class.dart';
import 'package:responsive_design/profile_card.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  bool passHidden = true;
  //there could be multiple form fields, so we use a GlobalKey to manage the form state
  //this assigns a unique key to the form, allowing us to validate and save the form state later
  final _formKey = GlobalKey<FormState>();

  //an object used for extracting the text from the TextFormField widgets,
  // allowing us to access the user input when the form is submitted
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false; // spinning circle loading

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, //ID for particular form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              header(),
              const SizedBox(height: 40),
              username(),
              const SizedBox(height: 40),
              password(),
              const SizedBox(height: 40),
              //show spinning cicle while logging in
              isLoading ? const CircularProgressIndicator() : _loginButton(),
              const SizedBox(height: 20),
              _signUpButton(),
      
            ],
          ),
        ),
      ),
    );
  }

  // header widget for the login screen
  Widget header() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: const Text(
        'Welcome Back!',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget username() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
    );
  }

  Widget password() {
    return TextFormField(
      controller: _passwordController,
      obscureText: passHidden,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(passHidden ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              passHidden = !passHidden;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: _submitLogin,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Login'),
    );

  }

  Widget _signUpButton() {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    },
    child: const Text('Don\'t have an account? Sign Up'),
  );
}


  void _submitLogin() async {
    if (!_formKey.currentState!.validate())
      return; //if the form is not valid, do not proceed

    setState(() => isLoading = true); // show loading indicator

    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await _authService.signIn(email: email, password: password);
      if (user != null) {
        // Navigate to the profile screen on successful login
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileCard()),
          );
        }
      }
    } catch (e) {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
        ),
        );
    } finally {
      if (mounted) {
        setState(() => isLoading = false); // hide loading indicator
      }
    }
  }
  
}
