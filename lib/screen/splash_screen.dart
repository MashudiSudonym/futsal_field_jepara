import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:futsal_field_jepara/screen/sign_in_screen.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

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
      () {
        Navigator.of(context).pushReplacementNamed(SignInScreen.id);
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
    // status bar and navigation bar colors
    FlutterStatusbarcolor.setStatusBarColor(kPrimaryColor);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setNavigationBarColor(kPrimaryColor);

    return Scaffold(
      body: Center(
        child: Image(
          width: MediaQuery.of(context).size.width / 2,
          image: AssetImage("assets/icon.png"),
        ),
      ),
    );
  }
}
