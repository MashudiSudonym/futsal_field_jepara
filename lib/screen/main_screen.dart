import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/screen/about_screen.dart';
import 'package:futsal_field_jepara/screen/booking_screen.dart';
import 'package:futsal_field_jepara/screen/home_screen.dart';
import 'package:futsal_field_jepara/screen/location_screen.dart';
import 'package:futsal_field_jepara/screen/search_screen.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final _layoutPage = [
    LocationScreen(),
    SearchScreen(),
    HomeScreen(),
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
    _selectedIndex = 2;
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
        ExtendedNavigator.ofRouter<Router>()
            .pushReplacementNamed(Routes.createUserScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _layoutPage.elementAt(_selectedIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0.0,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.shifting,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.home),
          title: Text("Home"),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.search),
          title: Text("Search"),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.compass),
          title: Text("Location"),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.trello),
          title: Text("Booking"),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.info),
          title: Text("About"),
          backgroundColor: kPrimaryColor,
          activeIcon: FaIcon(FontAwesomeIcons.infoCircle),
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onTapItem,
    );
  }
}
