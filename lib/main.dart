import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/route_guards.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lock screen rotate
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // status bar and navigation bar colors
    FlutterStatusbarcolor.setStatusBarColor(kPrimaryColor);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setNavigationBarColor(kPrimaryColor);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kPrimaryColor,
        fontFamily: "Poppins",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: kBodyTextColor),
        ),
      ),
      builder: (ctx, __) => ExtendedNavigator<Router>(
        router: Router(),
        guards: [AuthGuard()],
      ),
    );
  }
}
