import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking List"),
        elevation: 0.0,
      ),
      body: Center(
        child: Lottie.asset(
          "assets/error.json",
          height: MediaQuery.of(context).size.height / 100 * 25,
        ),
      ),
    );
  }
}
