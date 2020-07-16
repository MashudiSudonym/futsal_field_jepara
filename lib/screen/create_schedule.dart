import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final Firestore _fireStore = Firestore.instance;

class CreateSchedule extends StatefulWidget {
  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  final format = DateFormat("dd-MM-yyyy");
  String dateValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Jadwal"),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 100 * 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DateTimeField(
                format: format,
                onChanged: (value) {
                  setState(() {
                    dateValue = "${value.toString().split(' ')[0]}";
                  });
                },
                decoration: InputDecoration(
                  labelText: "Pilih Tanggal",
                  labelStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 100 * 3,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                    ),
                  ),
                ),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                    context: context,
                    initialDate: currentValue ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2222),
                  );
                }),
            Text(dateValue),
          ],
        ),
      ),
    );
  }
}
