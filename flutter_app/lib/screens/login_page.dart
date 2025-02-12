import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import the ApiService class for handling API calls
import 'register_page.dart'; // Import the RegisterPage for navigation to registration screen
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences for storing login state

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key})
      : super(
            key:
                key); // Constructor with an optional key for widget identification

  @override
  State<LoginPage> createState() =>
      _LoginPageState(); // Create the state for this widget
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController =
      TextEditingController(); // Controller to manage email input field
  final TextEditingController passwordController =
      TextEditingController(); // Controller to manage password input field
  final ApiService _apiService =
      ApiService(); // Instance of ApiService to call the login API

  // Function to handle login process
  void _login() async {
    String email = emailController.text; // Get the email entered by the user
    String password =
        passwordController.text; // Get the password entered by the user

    // Call loginUser function from ApiService
    final response = await _apiService.loginUser(email, password);

    if (!mounted)
      return; // Ensure the widget is still in the widget tree before updating the UI

    if (response.containsKey('user_id')) {
      FocusScope.of(context)
          .unfocus(); // Close the keyboard after login attempt

      // Show success SnackBar and navigate to home page after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(
            context, '/home'); // Navigate to home page after successful login
      });

      // Store the login flag in SharedPreferences to remember the login state
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Set the login status to true

      // Show a SnackBar indicating the login attempt was successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logging in...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // If login fails, show an error SnackBar with the error message
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
      appBar:
          AppBar(title: const Text('Login')), // AppBar with the title 'Login'
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the form elements
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the children vertically
          children: [
            // Email input field
            TextField(
              controller:
                  emailController, // Assign the controller for the email input
              decoration: const InputDecoration(
                  labelText: 'Email'), // Label for the email input field
            ),
            // Password input field
            TextField(
              controller:
                  passwordController, // Assign the controller for the password input
              decoration: const InputDecoration(
                  labelText: 'Password'), // Label for the password input field
              obscureText: true, // Obscure the text for the password field
            ),
            const SizedBox(
                height: 20), // Add space between input fields and button
            // Login button
            ElevatedButton(
              onPressed: _login, // Call the login function when pressed
              child: const Text('Login'), // Button text
            ),
            const SizedBox(
                height:
                    20), // Add space between the login button and sign-up link
            // Link to the register page if the user doesn't have an account
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RegisterPage()), // Navigate to RegisterPage
                );
              },
              child: const Text(
                "Don't have an account? Sign up", // Text to indicate registration option
                style: TextStyle(
                    color: Colors.lightGreen, // Color for the text
                    decoration: TextDecoration.underline), // Underline the text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
