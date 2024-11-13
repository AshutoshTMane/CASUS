import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'home_page.dart'; // Assuming HomePage is the entry point after logging out

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // Function to handle sign out
  void _signOut(BuildContext context) async {
    // Clear the user's login state from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navigate back to the HomePage or LoginPage after sign out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the user's email from SharedPreferences
    Future<String> _getUserEmail() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('userEmail') ??
          'No email found'; // Default text if no email
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<String>(
        future: _getUserEmail(), // Fetch email asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading state
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading email'));
          }

          // If the email is fetched successfully
          String userEmail = snapshot.data ?? 'No email found';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Picture Placeholder
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://www.example.com/placeholder.jpg', // Replace with actual user image
                  ),
                  child: const Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 20),
                // Username Placeholder
                const Text(
                  'Username/Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Display User Email
                Text(
                  'Email: $userEmail',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Sign Out Button
                ElevatedButton(
                  onPressed: () => _signOut(context),
                  child: const Text('Sign Out'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Sign out button color
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
