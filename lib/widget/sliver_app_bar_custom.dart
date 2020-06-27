import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SliverAppBarCustom extends SliverPersistentHeaderDelegate {
  final double minExtend;
  final double maxExtend;
  final String imageUrl;
  final String title;
  final String uid;

  SliverAppBarCustom({
    this.minExtend,
    @required this.maxExtend,
    @required this.imageUrl,
    @required this.title,
    @required this.uid,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: <Widget>[
        Hero(
          tag: uid,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Container(
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
        Positioned(
          left: MediaQuery.of(context).size.width / 100 * 13,
          right: MediaQuery.of(context).size.width / 100 * 5,
          bottom: MediaQuery.of(context).size.height / 100 * 1.2,
          child: Text(
            title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 6.5,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
            left: MediaQuery.of(context).size.width / 100 * 1,
            top: MediaQuery.of(context).size.height / 100 * 3.5,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: MediaQuery.of(context).size.width / 100 * 5,
              ),
              onPressed: () {
                ExtendedNavigator.of(context).pop();
              },
            )),
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
