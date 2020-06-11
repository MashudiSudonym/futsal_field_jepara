import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Futsal Field"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {},
          child: Center(
            child: Text("Sign Out"),
          ),
        ),
      ),
    );
  }
}
