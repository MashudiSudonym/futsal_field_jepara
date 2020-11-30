import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/route_guards.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart' as router_gr;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lock screen rotate
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
      builder: (context, __) => ExtendedNavigator<router_gr.Router>(
        router: router_gr.Router(),
        guards: [AuthGuard()],
      ),
    );
  }
}
