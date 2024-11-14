// register_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import ApiService for handling API calls (e.g., registration)

class RegisterPage extends StatefulWidget {
  @override
  _RegisterScreenState createState() =>
      _RegisterScreenState(); // Create the state for the RegisterPage
}

class _RegisterScreenState extends State<RegisterPage> {
  final TextEditingController _emailController =
      TextEditingController(); // Controller to manage email input
  final TextEditingController _passwordController =
      TextEditingController(); // Controller to manage password input
  final ApiService _apiService =
      ApiService(); // Instance of ApiService to handle API requests for registration

  // Function to handle user registration
  void _register() async {
    String email = _emailController.text; // Get the email entered by the user
    String password =
        _passwordController.text; // Get the password entered by the user

    // Call the registerUser function from ApiService to attempt registration
    await _apiService.registerUser(
        email, password); // Pass the email and password for registration
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Register')), // AppBar with the title 'Register'
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Padding around the form elements for better spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // Vertically center the children widgets
          children: [
            // Email input field
            TextField(
              controller:
                  _emailController, // Assign the controller for the email input
              decoration: InputDecoration(
                  labelText: 'Email'), // Label for the email input field
            ),
            // Password input field
            TextField(
              controller:
                  _passwordController, // Assign the controller for the password input
              decoration: InputDecoration(
                  labelText: 'Password'), // Label for the password input field
              obscureText:
                  true, // Obscure the text to hide the password as it's typed
            ),
            SizedBox(
                height:
                    20), // Add space between the password input field and the button
            // Register button
            ElevatedButton(
              onPressed:
                  _register, // Call the _register function when the button is pressed
              child: Text('Register'), // Text displayed on the register button
            ),
          ],
        ),
      ),
    );
  }
}
