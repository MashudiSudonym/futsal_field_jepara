import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart';
import 'package:futsal_field_jepara/widget/text_user_data_custom.dart';
import 'package:lottie/lottie.dart';
import 'package:somedialog/somedialog.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userUID = "-";

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  Future<void> _getUserData() async {
    final _user = await _auth.currentUser();
    setState(() {
      _userUID = _user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () async {
              await _signOutDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _fireStore
              .collection("users")
              .where("uid", isEqualTo: _userUID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final _data = snapshot.data.documents[index];

                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 100 * 2),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius:
                                MediaQuery.of(context).size.width / 100 * 20,
                            backgroundImage: (_data['imageProfile'] != null)
                                ? NetworkImage(_data['imageProfile'])
                                : Lottie.asset("assets/loading.json"),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height / 100 * 5,
                          ),
                          Text(
                            _data['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width / 100 * 6,
                              color: kTitleTextColor,
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height / 100 * 5,
                          ),
                          TextUserDataCustom(
                            contentText: _data['email'],
                            faIcon: FaIcon(
                              FontAwesomeIcons.solidEnvelope,
                              size: MediaQuery.of(context).size.width / 100 * 4,
                            ),
                          ),
                          TextUserDataCustom(
                            contentText: _data['address'],
                            faIcon: FaIcon(
                              FontAwesomeIcons.mapMarked,
                              size: MediaQuery.of(context).size.width / 100 * 4,
                            ),
                          ),
                          TextUserDataCustom(
                            contentText: _data['phone'],
                            faIcon: FaIcon(
                              FontAwesomeIcons.phoneAlt,
                              size: MediaQuery.of(context).size.width / 100 * 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Future _signOutDialog(BuildContext context) async {
    SomeDialog(
      context: context,
      path: "assets/report.json",
      title: "are you sure ?",
      content: "sign out of your account ?",
      submit: () async {
        await _auth.signOut();
        ExtendedNavigator.ofRouter<Router>().pushNamedAndRemoveUntil(
            Routes.splashScreen, (Route<dynamic> route) => false);
      },
      mode: SomeMode.Lottie,
      appName: "Futsal Field Jepara",
      buttonConfig: ButtonConfig(
        buttonDoneColor: kRedColor,
        dialogDone: "Sign out",
      ),
    );
  }
}
