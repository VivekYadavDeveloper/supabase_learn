import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_learn/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();

/*-------------------------------------------------------*/
  /*
  LOGOUT SESSION
   */
  /*-------------------------------------------------------*/

  void logout() async {
    await authService.signOut();
  }

  /*-------------------------------------------------------*/
  /*
  PICKED IMAGE
   */
/*-------------------------------------------------------*/

  File? _imageFile;
  bool _isUploading = false;

  Future<void> pickImage() async {
    try {
      if (Platform.isAndroid) {
        await requestPermission();
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  /*-------------------------------------------------------*/
  /*
  UPDATE/UPLOAD PROFILE - Notes In Supabase storage
   */
/*-------------------------------------------------------*/

  Future<void> uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Generate a unique file name
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';

      // Upload the image to Supabase storage
      final response = await Supabase.instance.client.storage
          .from('images') // Replace 'images' with your actual bucket name
          .upload(path, _imageFile!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully! File: $path')),
      );
    } catch (e) {
      // Handle and display errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints constraint) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(
                        _imageFile!) // Use FileImage if an image is selected
                    : null, // No image selected
                child: _imageFile == null
                    ? const Icon(Icons.person,
                        size: 50) // Placeholder icon if no image
                    : null,
              ),
              const SizedBox(height: 20),
              Text(userData ?? "No user data"),
              TextButton(
                onPressed: pickImage,
                child: const Text("Pick Profile"),
              ),
              TextButton(
                onPressed: _isUploading ? null : uploadImage,
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text("Update"),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      // Check for the appropriate permissions based on the Android version
      if (await Permission.photos.isDenied ||
          await Permission.photos.isPermanentlyDenied) {
        await Permission.photos.request();
      }
    }
  }
}
