import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart' as router_gr;

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class SplashScreen extends StatefulWidget {
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
        final usersRootSnapshot = _fireStore
            .collection("users")
            .where("uid", isEqualTo: user.uid)
            .snapshots();

        usersRootSnapshot.listen((data) {
          if (data.documents.isEmpty) {
            ExtendedNavigator.ofRouter<router_gr.Router>()
                .pushReplacementNamed(router_gr.Routes.createUserScreen);
          } else {
            ExtendedNavigator.ofRouter<router_gr.Router>()
                .pushReplacementNamed(router_gr.Routes.mainScreen);
          }
        });
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
