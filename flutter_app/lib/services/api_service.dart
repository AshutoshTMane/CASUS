// lib/services/api_service.dart
import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:http/http.dart' as http; // Import HTTP package for API requests

class ApiService {
  // Base URL for the FastAPI backend, configured for the Android emulator
  final String _baseUrl = 'http://10.0.2.2:8000';

  // Function to register a user with email and password
  Future<void> registerUser(String email, String password) async {
    try {
      // Send a POST request to the FastAPI /register endpoint
      final response = await http.post(
        Uri.parse(
            '$_baseUrl/register'), // Construct URL for registration endpoint
        headers: {
          'Content-Type': 'application/json'
        }, // Set content type to JSON
        body: json.encode({
          // Convert email and password to JSON format
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // On successful registration, log the server's response
        print('Registration successful: ${json.decode(response.body)}');
      } else {
        // On error, log the response body to get error details
        print('Error: ${response.body}');
      }
    } catch (e) {
      // Catch any exceptions, such as network errors, and log them
      print('Failed to register: $e');
    }
  }

  // Function to log in a user with email and password
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      // Send a POST request to the FastAPI /login endpoint
      final response = await http.post(
        Uri.parse('$_baseUrl/login'), // Construct URL for login endpoint
        headers: {
          'Content-Type': 'application/json'
        }, // Set content type to JSON
        body: json.encode({
          // Convert email and password to JSON format
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // On successful login, decode and return the response body
        return json.decode(response.body);
      } else {
        // On failed login, log the response and return an error message
        print('Login failed: ${response.body}');
        return {"error": "Login failed"};
      }
    } catch (e) {
      // Catch any exceptions, log the error, and return a network error message
      print('Failed to login: $e');
      return {"error": "Network error"};
    }
  }
}
