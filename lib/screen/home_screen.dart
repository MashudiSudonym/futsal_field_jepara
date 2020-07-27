import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/model/data.dart' as data;
import 'package:futsal_field_jepara/model/futsal_field.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        stream: data.loadAllFutsalFields(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Lottie.asset(
                "assets/loading.json",
                height: MediaQuery.of(context).size.height / 100 * 25,
              ),
            );
          if (snapshot.hasError)
            return Center(
              child: Lottie.asset(
                "assets/error.json",
                height: MediaQuery.of(context).size.height / 100 * 25,
              ),
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Lottie.asset(
                  "assets/loading.json",
                  height: MediaQuery.of(context).size.height / 100 * 25,
                ),
              );
            default:
              return Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 100 * 14,
                ),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final futsalField = FutsalFields.fromMap(
                        snapshot.data.documents[index].data);
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 375),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width / 100 * 2,
                              horizontal:
                                  MediaQuery.of(context).size.width / 100 * 2,
                            ),
                            child: ListTile(
                              onTap: () {
                                ExtendedNavigator.ofRouter<Router>().pushNamed(
                                  Routes.futsalFieldInformation,
                                  arguments: FutsalFieldInformationArguments(
                                    uid: futsalField.uid,
                                  ),
                                );
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Hero(
                                    tag: futsalField.uid,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                100 *
                                                25,
                                        imageUrl: futsalField.image,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: FaIcon(
                                            FontAwesomeIcons
                                                .exclamationTriangle,
                                          ),
                                        ),
                                        fit: BoxFit.cover,
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
                                      futsalField.name.toUpperCase(),
                                      style: TextStyle(
                                          color: kTitleTextColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              100 *
                                              5),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                futsalField.address.toUpperCase(),
                                style: TextStyle(
                                    color: kBodyTextColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            100 *
                                            3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 100 * 2),
                ),
              );
          }
        },
      ),
    );
  }
}
