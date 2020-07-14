import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

class CreateSchedule extends StatefulWidget {
  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Jadwal"),
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
