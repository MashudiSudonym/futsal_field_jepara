import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;
final FirebaseStorage _fireStorage = FirebaseStorage.instance;

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  String _userPhone = "";
  String _userUid = "";

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getUserData() async {
    final user = await _auth.currentUser();

    setState(() {
      _userUid = user.uid;
      _userPhone = user.phoneNumber;
    });

    print(_userPhone);
  }

  @override
  Widget build(BuildContext context) {
    // check keyboard status for conditional layout
    bool _isKeyboardShowing = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Complete your profile"),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: FaIcon(FontAwesomeIcons.save),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 100 * 5),
                      width: MediaQuery.of(context).size.width / 100 * 40,
                      height: MediaQuery.of(context).size.width / 100 * 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/ben-sweet-2LowviVHZ-E-unsplash.jpg"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(90),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 100 * 2,
                      bottom: MediaQuery.of(context).size.width / 100 * 5,
                      child: FlatButton(
                        onPressed: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width / 100 * 12,
                          height: MediaQuery.of(context).size.width / 100 * 12,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            image: DecorationImage(
                              image: AssetImage("assets/camera-icon-55.jpg"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(90),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 7,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 100 * 5,
                    right: MediaQuery.of(context).size.width / 100 * 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Full Name : ",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5,
                            fontWeight: FontWeight.bold,
                            color: kTitleTextColor,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextField(
                          cursorColor: kTitleTextColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nama Lengkap",
                            hintStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 100 * 5,
                              color: kTextLightColor,
                            ),
                          ),
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5,
                            fontWeight: FontWeight.bold,
                            color: kTitleTextColor,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 100 * 5,
                    right: MediaQuery.of(context).size.width / 100 * 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "E-mail : ",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5,
                            fontWeight: FontWeight.bold,
                            color: kTitleTextColor,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextField(
                          cursorColor: kTitleTextColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "E-mail",
                            hintStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 100 * 5,
                              color: kTextLightColor,
                            ),
                          ),
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5,
                            fontWeight: FontWeight.bold,
                            color: kTitleTextColor,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 100 * 5,
                    right: MediaQuery.of(context).size.width / 100 * 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Address : ",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5,
                            fontWeight: FontWeight.bold,
                            color: kTitleTextColor,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextField(
                          cursorColor: kTitleTextColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Address",
                            hintStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 100 * 5,
                              color: kTextLightColor,
                            ),
                          ),
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5,
                            fontWeight: FontWeight.bold,
                            color: kTitleTextColor,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width / 100 * 3,
                    left: MediaQuery.of(context).size.width / 100 * 5,
                    right: MediaQuery.of(context).size.width / 100 * 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Phone : ",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5,
                            fontWeight: FontWeight.bold,
                            color: kTitleTextColor,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          _userPhone,
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5,
                            fontWeight: FontWeight.bold,
                            color: kTitleTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
