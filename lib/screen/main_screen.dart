import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/screen/about_screen.dart';
import 'package:futsal_field_jepara/screen/booking_screen.dart';
import 'package:futsal_field_jepara/screen/home_screen.dart';
import 'package:futsal_field_jepara/screen/location_screen.dart';
import 'package:futsal_field_jepara/screen/search_screen.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

class MainScreen extends StatefulWidget {
  static const String id = "home_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final _layoutPage = [
    HomeScreen(),
    SearchScreen(),
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
    _selectedIndex = 2;
    super.initState();
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
          icon: Icon(Icons.home),
          title: Text("Home"),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text("Search"),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          title: Text("Location"),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          title: Text("Booking"),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          title: Text("About"),
          backgroundColor: kPrimaryColor,
          activeIcon: Icon(Icons.info),
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onTapItem,
    );
  }
}
