import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for shared preferences to check login status
import 'login_page.dart'; // Import LoginPage for login redirection
import 'profile_page.dart'; // Import ProfilePage for profile page
import 'package:google_maps_flutter/google_maps_flutter.dart';

// HomePage widget that is Stateful to handle dynamic UI updates based on user actions (e.g., navigation)
class HomePage extends StatefulWidget {
  const HomePage({Key? key})
      : super(
            key:
                key); // Constructor with optional key for widget identification

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(); // Create the state for this widget
}

class _MyHomePageState extends State<HomePage> {
  int _selectedIndex =
      0; // Track the selected tab index (Home, Search, Profile)
  bool isLoggedIn = false; // Track whether the user is logged in

  // A list of pages to be displayed for each tab (Home, Search, Profile)
  static const List<Widget> _pages = <Widget>[
    Center(
        child: Text('Home Page',
            style: TextStyle(fontSize: 24))), // Home page content
    Center(
        child: Text('Search Page',
            style: TextStyle(fontSize: 24))), // Search page content
    SizedBox
        .shrink(), // Placeholder for the Profile tab (it's handled dynamically)
  ];

  // Function to check if the user is logged in by accessing SharedPreferences
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Get shared preferences instance
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ??
          false; // Set login state (default to false if no value exists)
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status when the page is initialized
  }

  // Function to handle bottom navigation tab item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index
    });

    if (_selectedIndex == 2) {
      // If Profile tab is selected
      if (isLoggedIn) {
        // If user is logged in, navigate to ProfilePage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      } else {
        // If user is not logged in, navigate to LoginPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to CASUS!'), // App bar title
      ),
      body: _pages[
          _selectedIndex], // Display the selected page content based on selected tab
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'), // Home tab item
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'), // Search tab item
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'), // Profile tab item
        ],
        currentIndex: _selectedIndex, // Set the currently selected tab
        selectedItemColor: Colors.lightGreen, // Color for selected tab
        onTap: _onItemTapped, // Function to handle tab item taps
      ),
    );
  }
}
