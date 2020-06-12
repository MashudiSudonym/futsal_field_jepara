import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/screen/sign_in_screen.dart';

import 'main_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
        final FirebaseUser user = await _auth.currentUser();
        user == null
            ? Navigator.of(context).pushReplacementNamed(SignInScreen.id)
            : Navigator.of(context).pushReplacementNamed(MainScreen.id);
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
