import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Default to false if no value
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CASUS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) =>
            const HomePage(), // Ensure HomePage is registered here
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
