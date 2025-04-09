import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'chat_page.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/landmark_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'CASUS',
        theme: ThemeData.dark(),
        initialRoute: '/login',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/profile': (context) => const ProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/chat': (context) => const ChatPage(),
          '/landmark': (context) => const LandmarkScreen(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng _currentPosition = const LatLng(37.422, -122.084); // Google Plex default
  bool _locationObtained = false;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setupInitialMarker(); // Add initial marker immediately
    _getCurrentLocation();
  }

  // Create initial marker right away
  void _setupInitialMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('user'),
          position: _currentPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Red is more visible
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      };
    });
  }

  void _getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          // If service is still not enabled, use default location
          print("Location services not enabled, using default position");
          setState(() => _locationObtained = true);
          return;
        }
      }

      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) {
          // If permission is still not granted, use default location
          print("Location permission not granted, using default position");
          setState(() => _locationObtained = true);
          return;
        }
      }
      
      // Get initial location
      print("Getting initial location...");
      LocationData locationData = await _location.getLocation();
      print("Initial location received: ${locationData.latitude}, ${locationData.longitude}");
      _updateLocation(locationData);
      
      // Set up continuous location updates with more debugging
      _location.onLocationChanged.listen((LocationData currentLocation) {
        print("Location update: ${currentLocation.latitude}, ${currentLocation.longitude}");
        _updateLocation(currentLocation);
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() => _locationObtained = true);
    }
  }

  void _updateLocation(LocationData locationData) {
    if (locationData.latitude == null || locationData.longitude == null) {
      print("Invalid location data received");
      return;
    }
    
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
      _locationObtained = true;
      
      // Update the marker with a more visible icon
      _markers = {
        Marker(
          markerId: const MarkerId('user'),
          position: _currentPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // More visible
          infoWindow: const InfoWindow(title: 'Your Location'),
          visible: true, // Explicitly set visibility
        ),
      };
      
      print("Marker updated to: ${_currentPosition.latitude}, ${_currentPosition.longitude}");
    });
    
    // Move camera only if controller is initialized
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 17),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('CASUS'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Text(
              'Welcome to CASUS, ${authService.currentUser?.displayName ?? 'User'}!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 17),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  mapType: MapType.normal,
                  markers: _markers,
                  onMapCreated: (controller) {
                    setState(() {
                      _mapController = controller;
                    });
                    if (_locationObtained) {
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: _currentPosition, zoom: 17),
                      ));
                    }
                    print("Map created with ${_markers.length} markers");
                  },
                ),
                if (!_locationObtained) const Center(child: CircularProgressIndicator()),
                // Add a debug overlay to show current coordinates
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.black.withOpacity(0.7),
                    child: Text(
                      'Lat: ${_currentPosition.latitude.toStringAsFixed(5)}\nLng: ${_currentPosition.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade900, // Slightly lighter than black
        selectedItemColor: Colors.green.shade400,
        unselectedItemColor: Colors.lightGreen.shade300, // Brighter green
        type: BottomNavigationBarType.fixed,  // Fixed for 4+ items
        elevation: 8, // Add shadow
        iconSize: 28, // Larger icons
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            activeIcon: Icon(Icons.home_filled, size: 30, color: Colors.lightGreenAccent),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            activeIcon: Icon(Icons.person, size: 30, color: Colors.lightGreenAccent),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 28),
            activeIcon: Icon(Icons.settings, size: 30, color: Colors.lightGreenAccent),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 28),
            activeIcon: Icon(Icons.chat, size: 30, color: Colors.lightGreenAccent),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt, size: 28),
            activeIcon: Icon(Icons.camera_alt, size: 30, color: Colors.lightGreenAccent),
            label: 'Landmark ID',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/profile');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
            case 3:
              Navigator.pushNamed(context, '/chat');
              break;
            case 4:
              Navigator.pushNamed(context, '/landmark');
              break;
          }
        },
      ),
    );
  }
}