// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  ProfileScreen({required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 16),
            Text("Payal Adatiya",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("payal@gamil.com", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.edit),
              label: Text("Edit Profile"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EditProfileScreen()));
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.brightness_6),
              label: Text("Switch Theme"),
              onPressed: onThemeToggle,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text("Logout"),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoginScreen(onThemeToggle: onThemeToggle)),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
