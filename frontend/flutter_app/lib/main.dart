import 'package:flutter/material.dart';

// Starting point of the Flutter application
void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  // Constructor
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Builds the MaterialApp widget, which provides material design theme and structure
    return MaterialApp(
      title: 'Hello World Demo Application', // App title
      theme: ThemeData(
        primarySwatch: Colors.lightGreen, // Primary theme color
      ),
      home: const MyHomePage(), // Sets the home screen to MyHomePage widget
    );
  }
}

// A StatefulWidget that represents the home page
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// State class for MyHomePage to manage state changes
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // List of widgets for each page
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  // Function to handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Updates the selected index, triggering a rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    // Main page layout with app bar, body, and bottom navigation bar
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to CASUS!'), // Title for the app bar
      ),
      body: _pages[_selectedIndex], // Displays content based on selected index
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Home navigation item
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // Search navigation item
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          // Profile navigation item
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Highlights the currently selected item
        selectedItemColor: Colors.lightGreen, // Color for the selected item
        onTap: _onItemTapped, // Calls _onItemTapped when an item is tapped
      ),
    );
  }
}
