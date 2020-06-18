import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/screen/main_screen.dart';
import 'package:futsal_field_jepara/screen/sign_in_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class SplashScreen extends StatefulWidget {
  static const String id = "splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  removeScreen() {
    return _timer = Timer(
      Duration(seconds: 2),
      () async {
        final user = await _auth.currentUser();
        if (user == null) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.id);
        } else {
          final usersRootSnapshot = _fireStore
              .collection("users")
              .where("uid", isEqualTo: user.uid)
              .snapshots();

          usersRootSnapshot.listen((data) {
            if (data.documents.isEmpty) {
              Navigator.of(context).pushReplacementNamed(MainScreen.id);
            } else {
              Navigator.of(context).pushReplacementNamed(MainScreen.id);
            }
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    removeScreen();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          width: MediaQuery.of(context).size.width / 100 * 50,
          image: AssetImage("assets/icon.png"),
        ),
      ),
    );
  }
}
