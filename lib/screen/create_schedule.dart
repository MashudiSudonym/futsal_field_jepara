import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

final Firestore _fireStore = Firestore.instance;

class CreateSchedule extends StatefulWidget {
  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  TextEditingController _datePickerController = TextEditingController();
  String _dateValue = "";
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _datePickerController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2222),
    );

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        _dateValue = _date.toString().split(' ')[0];
        _datePickerController = TextEditingController(text: _dateValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Buat Jadwal"),
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 100 * 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                onTap: () {
                  setState(() {
                    _selectDate(context);
                  });
                },
                controller: _datePickerController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "$_dateValue",
                  labelText: "Pilih Tanggal",
                  labelStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 100 * 4,
                    color: kTitleTextColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kLogoLightGreenColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kLogoLightGreenColor,
                    ),
                  ),
                ),
              ),
              Text(_datePickerController.text),
            ],
          ),
        ),
      ),
    );
  }
}
