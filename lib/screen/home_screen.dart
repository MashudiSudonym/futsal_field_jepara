import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/screen/sign_in_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Futsal Field Jepara"),
        elevation: 0.0,
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
