import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/model/futsal_field.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart';

final Firestore _fireStore = Firestore.instance;

class FutsalFieldSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection("futsalFields")
          .where("name", isEqualTo: query)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Image(
              image: AssetImage("assets/notfound.png"),
              height: MediaQuery.of(context).size.height / 100 * 25,
            ),
          );
        if (!snapshot.hasData)
          return Center(
            child: Image(
              image: AssetImage("assets/nodata.png"),
              height: MediaQuery.of(context).size.height / 100 * 25,
            ),
          );
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
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
                          horizontal:
                              MediaQuery.of(context).size.width / 100 * 2,
                        ),
                        child: ListTile(
                          onTap: () {
                            ExtendedNavigator.ofRouter<Router>().pushNamed(
                              Routes.futsalFieldInformation,
                              arguments: FutsalFieldInformationArguments(
                                  uid: futsalFields.uid),
                            );
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Hero(
                                tag: futsalFields.uid,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    height: MediaQuery.of(context).size.height /
                                        100 *
                                        25,
                                    imageUrl: futsalFields.image,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.exclamationTriangle,
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
                                  futsalFields.name.toUpperCase(),
                                  style: TextStyle(
                                      color: kTitleTextColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
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
                                fontSize: MediaQuery.of(context).size.width /
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
            );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
