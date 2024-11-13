// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to use the correct URL for the emulator
  final String _baseUrl = 'http://10.0.2.2:8000'; // For Android emulator

  // Register the user
  Future<void> registerUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'), // FastAPI endpoint for registration
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Success: Show success message or navigate to another page
        print('Registration successful: ${json.decode(response.body)}');
      } else {
        // Error: Show error message
        print('Error: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions like network errors
      print('Failed to register: $e');
    }
  }

  // Login user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Success: return response data
      } else {
        print('Login failed: ${response.body}');
        return {"error": "Login failed"};
      }
    } catch (e) {
      print('Failed to login: $e');
      return {"error": "Network error"};
    }
  }
}
