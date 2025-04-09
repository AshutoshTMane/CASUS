import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class LandmarkScreen extends StatefulWidget {
  const LandmarkScreen({Key? key}) : super(key: key);

  @override
  _LandmarkScreenState createState() => _LandmarkScreenState();
}

class _LandmarkScreenState extends State<LandmarkScreen> {
  File? _selectedImage;
  bool _loading = false;
  Map<String, dynamic>? _landmarkData;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // or .camera

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _landmarkData = null;
      });

      await _identifyLandmark(File(pickedFile.path));
    }
  }

  Future<void> _identifyLandmark(File imageFile) async {
    setState(() {
      _loading = true;
    });

    final uri = Uri.parse('http://10.0.2.2:8000/identify_landmark'); // Use 127.0.0.1 if testing in browser
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['landmarks'] != null && data['landmarks'].isNotEmpty) {
          setState(() {
            _landmarkData = data['landmarks'][0];
          });
        } else {
          _showSnackbar('No recognizable landmarks found.');
        }
      } else {
        _showSnackbar('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Failed to connect to server.');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildLandmarkCard() {
    if (_landmarkData == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _landmarkData!['name'] ?? 'Unknown',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _landmarkData!['location']['address'] ?? 'Address unavailable',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Text(
              _landmarkData!['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landmark Identifier'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload an Image'),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          if (_selectedImage != null && !_loading) _buildLandmarkCard(),
        ],
      ),
    );
  }
}
