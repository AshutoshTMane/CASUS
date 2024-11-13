import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isLoggedIn = false; // Track login state

  // Pages for each tab
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    SizedBox.shrink(), // Placeholder for Profile tab
  ];

  // Check login state using SharedPreferences
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status on page load
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 2) {
      // If Profile tab is tapped
      if (isLoggedIn) {
        // If logged in, show ProfilePage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      } else {
        // If not logged in, redirect to LoginPage
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
        title: const Text('Welcome to CASUS!'),
      ),
      body: _pages[_selectedIndex], // Show the selected page (Home or Search)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped, // Handle tab tap
      ),
    );
  }
}
