import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/model/futsal_field.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final mainRoot = _fireStore.collection("futsalFields");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Futsal Field Jepara"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.userCircle),
            onPressed: () async {
              ExtendedNavigator.ofRouter<Router>()
                  .pushNamed(Routes.profileScreen);
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
            ); // show loa// ding progress indicator;
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              final futsalFields =
                  FutsalFields.fromMap(snapshot.data.documents[index].data);
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width / 100 * 2,
                        horizontal: MediaQuery.of(context).size.width / 100 * 2,
                      ),
                      child: ListTile(
                        onTap: () {
                          print(futsalFields.uid);
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height:
                                  MediaQuery.of(context).size.height / 100 * 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: kShadowBlueColor,
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(futsalFields.image),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height /
                                    100 *
                                    1,
                              ),
                              child: Text(
                                futsalFields.name.toUpperCase(),
                                style: TextStyle(
                                    color: kTitleTextColor,
                                    fontSize:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width /
                                        100 *
                                        5),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          futsalFields.address.toUpperCase(),
                          style: TextStyle(
                              color: kBodyTextColor,
                              fontSize:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width / 100 * 3),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 100 * 2),
          );
        },
      ),
    );
  }
}
