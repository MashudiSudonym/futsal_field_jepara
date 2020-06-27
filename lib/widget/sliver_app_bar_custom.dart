import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

class SliverAppBarCustom extends SliverPersistentHeaderDelegate {
  final double minExtend;
  final double maxExtend;
  final String imageUrl;
  final String title;
  final String uid;
  final GeoPoint location;

  SliverAppBarCustom({
    this.minExtend,
    @required this.maxExtend,
    @required this.imageUrl,
    @required this.title,
    @required this.uid,
    @required this.location,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: <Widget>[
        Opacity(
          opacity: (1 - shrinkOffset / maxExtend),
          child: Hero(
            tag: uid,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Opacity(
          opacity: (1 - shrinkOffset / maxExtend),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54],
                stops: [0.5, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.repeated,
              ),
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 100 * 13,
          right: MediaQuery.of(context).size.width / 100 * 5,
          bottom: MediaQuery.of(context).size.height / 100 * 0.5,
          child: Text(
            title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 6.5,
              color: (shrinkOffset == 0.0) ? Colors.white : Colors.black,
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 100 * 3,
          top: MediaQuery.of(context).size.height / 100 * 4.8,
          child: CircleAvatar(
            radius: 19,
            backgroundColor:
                (shrinkOffset == 0.0) ? Colors.white : Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: MediaQuery.of(context).size.width / 100 * 5,
              ),
              onPressed: () {
                ExtendedNavigator.of(context).pop();
              },
            ),
          ),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width / 100 * 5,
          top: MediaQuery.of(context).size.width / 100 * 63 - shrinkOffset,
          child: Opacity(
            opacity: (1 - shrinkOffset / maxExtend),
            child: GestureDetector(
              onTap: () async {
                final availableMap = await MapLauncher.installedMaps;
                await availableMap.first.showMarker(
                  coords: Coords(location.latitude, location.longitude),
                  title: title,
                  description: "Location of $title",
                );
              },
              child: Card(
                elevation: 4.0,
                child: Container(
                  height: MediaQuery.of(context).size.width / 100 * 15,
                  width: MediaQuery.of(context).size.width / 100 * 15,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.mapMarkedAlt,
                      size: MediaQuery.of(context).size.width / 100 * 8,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  double get maxExtent => maxExtend;

  @override
  double get minExtent => minExtend;
}
