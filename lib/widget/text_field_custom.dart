import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

class TextFieldCustom extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;

  TextFieldCustom({Key key, this.title, this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 100 * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 5,
              fontWeight: FontWeight.bold,
              color: kTitleTextColor,
            ),
          ),
          TextField(
            cursorColor: kTitleTextColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: title,
              hintStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 5,
                color: kTextLightColor,
              ),
            ),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 5,
              fontWeight: FontWeight.bold,
              color: kTitleTextColor,
            ),
            keyboardType: TextInputType.text,
            controller: textEditingController,
          ),
        ],
      ),
    );
  }
}
