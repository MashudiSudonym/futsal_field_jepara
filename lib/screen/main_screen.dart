import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/screen/about_screen.dart';
import 'package:futsal_field_jepara/screen/booking_screen.dart';
import 'package:futsal_field_jepara/screen/home_screen.dart';
import 'package:futsal_field_jepara/screen/location_screen.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart' as router_gr;

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  final _layoutPage = [
    HomeScreen(),
    LocationScreen(),
    BookingScreen(),
    AboutScreen()
  ];

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _selectedIndex = 0;
    _checkUserProfile();
    super.initState();
  }

  Future<void> _checkUserProfile() async {
    final user = await _auth.currentUser();
    final usersRootSnapshot = _fireStore
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .snapshots();

    usersRootSnapshot.listen((data) {
      if (data.documents.isEmpty) {
        ExtendedNavigator.ofRouter<router_gr.Router>()
            .pushReplacementNamed(router_gr.Routes.createUserScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            child: _layoutPage.elementAt(_selectedIndex),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: -MediaQuery.of(context).size.height / 100 * 2.8,
            child: CurvedNavigationBar(
              key: _bottomNavigationKey,
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOutSine,
              animationDuration: Duration(milliseconds: 600),
              items: <Widget>[
                FaIcon(
                  FontAwesomeIcons.home,
                  size: 30,
                ),
                FaIcon(
                  FontAwesomeIcons.compass,
                  size: 30,
                ),
                FaIcon(
                  FontAwesomeIcons.trello,
                  size: 30,
                ),
                FaIcon(
                  FontAwesomeIcons.infoCircle,
                  size: 30,
                ),
              ],
              index: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _onTapItem(index);
                });
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
