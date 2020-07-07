import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About This App"),
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
