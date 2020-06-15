import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "profile_screen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 0.0,
      ),
      body: Center(
        child: Image(
          image: AssetImage("assets/icon.png"),
        ),
      ),
    );
  }
}
