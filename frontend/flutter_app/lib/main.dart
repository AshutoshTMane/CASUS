import 'package:flutter/material.dart'; // Import Flutter's material design package
import 'screens/login_page.dart'; // Import the login page screen
import 'screens/home_page.dart'; // Import the home page screen
import 'screens/profile_page.dart'; // Import the profile page screen
import 'package:shared_preferences/shared_preferences.dart'; // Import for local storage

// Main function to start the app
void main() {
  runApp(MyApp()); // Runs the MyApp widget as the root of the app
}

// Root widget of the app, responsible for setting up app-wide configurations
class MyApp extends StatelessWidget {
  // Async function to check if the user is logged in
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // Access shared preferences
    return prefs.getBool('isLoggedIn') ??
        false; // Returns login status, defaults to false if not set
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CASUS', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set the primary color theme
      ),
      initialRoute: '/home', // Initial route of the app, opens HomePage
      routes: {
        // Define the available routes in the app
        '/login': (context) => const LoginPage(), // Route to the login page
        '/home': (context) => const HomePage(), // Route to the home page
        '/profile': (context) =>
            const ProfilePage(), // Route to the profile page
      },
    );
  }
}
