import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "sign_in";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String countryCodeInput;
  final phoneInputController = TextEditingController();

  // flutter toast for show data
  void showToast(String text) {
    Fluttertoast.showToast(
      msg: "$text",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  @override
  void dispose() {
    phoneInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // status bar and navigation bar colors
    FlutterStatusbarcolor.setStatusBarColor(kPrimaryColor);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setNavigationBarColor(kPrimaryColor);
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // image logo position
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top,
                bottom: isKeyboardShowing
                    ? MediaQuery.of(context).size.width / 100 * 25
                    : MediaQuery.of(context).size.width / 100 * 50,
              ),
            ),
            // image logo
            Center(
              child: Image(
                image: AssetImage("assets/icon.png"),
                width: MediaQuery.of(context).size.width / 100 * 50,
              ),
            ),
            // country code phone number and text field
            buildCountryCodePhoneNumberField(context),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 2,
            ),
            // sign in button layout
            buildSignInButton(context),
          ],
        ),
      ),
    );
  }

  Padding buildCountryCodePhoneNumberField(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: MediaQuery.of(context).size.width / 100 * 15),
      child: Row(
        children: <Widget>[
          // country code
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[100],
            ),
            child: CountryCodePicker(
              onInit: (countryCode) => countryCodeInput = countryCode.dialCode,
              initialSelection: 'ID',
              showCountryOnly: false,
              alignLeft: false,
              textStyle: TextStyle(
                color: kTitleTextColor,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 100 * 2,
          ),
          // phone number input
          Container(
            width: MediaQuery.of(context).size.width / 100 * 45,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 100 * 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: kBackgroundColor,
            ),
            child: TextField(
              cursorColor: kTitleTextColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Phone Number",
                hintStyle: TextStyle(
                  fontSize: MediaQuery
                      .of(context)
                      .size
                      .width / 100 * 5,
                  color: kTextLightColor,
                ),
              ),
              style: TextStyle(
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .width / 100 * 5,
                fontWeight: FontWeight.bold,
                color: kTitleTextColor,
              ),
              keyboardType: TextInputType.number,
              controller: phoneInputController,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildSignInButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery
            .of(context)
            .size
            .width / 100 * 4,
      ),
      child: FlatButton(
        child: Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              fontSize: MediaQuery
                  .of(context)
                  .size
                  .width / 100 * 5,
              fontWeight: FontWeight.w600,
              color: kTitleTextColor,
            ),
          ),
        ),
        onPressed: () {
          showToast("$countryCodeInput${phoneInputController.text}");
          // Navigator.of(context).pushNamed(VerificationScreen.id);
        },
      ),
    );
  }
}
