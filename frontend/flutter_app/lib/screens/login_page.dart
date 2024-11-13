import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void _login() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Call loginUser function
    final response = await _apiService.loginUser(email, password);

    if (!mounted) return;

    if (response.containsKey('user_id')) {
      FocusScope.of(context).unfocus();

      // Show success SnackBar and navigate to home after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home');
      });

      // Store login flag in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Set login flag

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logging in...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Show error SnackBar if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['error'] ?? 'Login failed'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login, // Call the login function
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                    color: Colors.lightGreen,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
