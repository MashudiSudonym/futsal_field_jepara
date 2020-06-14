import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/model/futsal_field.dart';
import 'package:futsal_field_jepara/screen/sign_in_screen.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final mainRoot = _fireStore.collection("futsalFields");

  @override
  void initState() {
    if (_auth.currentUser() == null)
      Navigator.of(context).pushReplacementNamed(SignInScreen.id);
    super.initState();
  }

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
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            ); // show loading progress indicator;
          return ListView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 100 * 2),
            children: snapshot.data.documents.map(
              (data) {
                final futsalFields = FutsalFields.fromSnapshot(data);

                return Padding(
                  key: ValueKey(futsalFields.uid),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width / 100 * 1,
                    horizontal: MediaQuery.of(context).size.width / 100 * 2,
                  ),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(
                        futsalFields.name.toUpperCase(),
                        style: TextStyle(
                            color: kTitleTextColor,
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 5),
                      ),
                      subtitle: Text(
                        futsalFields.address.toUpperCase(),
                        style: TextStyle(
                            color: kBodyTextColor,
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 3),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
