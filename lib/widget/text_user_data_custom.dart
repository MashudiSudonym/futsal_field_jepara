import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

class TextUserDataCustom extends StatelessWidget {
  final String contentText;
  final FaIcon faIcon;

  TextUserDataCustom({Key key, this.contentText, this.faIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100 * 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          SizedBox(width: MediaQuery.of(context).size.width / 100 * 10,),
          faIcon,
          SizedBox(width: MediaQuery.of(context).size.width / 100 * 5,),
          Flexible(
            child: SelectableText(
              contentText,
              enableInteractiveSelection: true,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 4,
                color: kBodyTextColor,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width / 100 * 5,),
        ],
      ),
    );
  }
}
