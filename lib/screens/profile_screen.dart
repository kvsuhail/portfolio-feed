// screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    // You can pass user details to this screen to display real profile data
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Text(
          'Profile Page (build with real data)',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
