import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/screen/sign_in_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var mainRoot = _fireStore.collection("futsalFields");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Futsal Field Jepara"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call_missed_outgoing),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacementNamed(SignInScreen.id);
            },
          ), // set app bar icon and added action
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: mainRoot.snapshots(),
        builder: (context, snapshot) {
          return null;
        },
      ),
    );
  }
}
