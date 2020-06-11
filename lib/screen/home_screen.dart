import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'sign_in_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
        title: Text("Futsal Field Jepara"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            await _auth.signOut();
            Navigator.of(context).pushReplacementNamed(SignInScreen.id);
          },
          child: Center(
            child: Text("Sign Out"),
          ),
        ),
      ),
    );
  }
}
