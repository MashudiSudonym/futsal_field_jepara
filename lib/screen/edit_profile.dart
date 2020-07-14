import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ubah Profil",
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: kRedColor,
      ),
    );
  }
}
