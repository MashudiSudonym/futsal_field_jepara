import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/screen/sign_in_screen.dart';
import 'package:futsal_field_jepara/screen/splash_screen.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  static const String id = "profile_screen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    if (_auth.currentUser() == null)
      Navigator.of(context).pushReplacementNamed(SignInScreen.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _signOutDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Image(
          image: AssetImage("assets/icon.png"),
        ),
      ),
    );
  }

  Future _signOutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "sign out of your account ?",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 5,
              fontWeight: FontWeight.w600,
              color: kBodyTextColor,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 100 * 5,
                      fontWeight: FontWeight.w500,
                      color: kBodyTextColor,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Row(
                children: <Widget>[
                  Text(
                    "Oke",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 100 * 5,
                      fontWeight: FontWeight.w500,
                      color: kRedColor,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    SplashScreen.id, (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
