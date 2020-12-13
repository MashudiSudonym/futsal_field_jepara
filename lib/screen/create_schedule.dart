import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/model/data.dart';
import 'package:futsal_field_jepara/model/schedule.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart' as router_gr;
import 'package:interval_time_picker/interval_time_picker.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateSchedule extends StatefulWidget {
  final String uid;
  final String name;
  final String phone;
  final String numberOfFlooring;
  final String numberOfSynthesis;
  final int priceDayFlooring;
  final int priceNightFlooring;
  final int priceDaySynthesis;
  final int priceNightSynthesis;

  const CreateSchedule({
    @required this.uid,
    @required this.name,
    @required this.phone,
    @required this.numberOfFlooring,
    @required this.numberOfSynthesis,
    @required this.priceDayFlooring,
    @required this.priceNightFlooring,
    @required this.priceDaySynthesis,
    @required this.priceNightSynthesis,
  });

  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _checkFormKey = GlobalKey<FormState>();
  TextEditingController _startTimePickerController = TextEditingController();
  String _startTimeValue = '';
  TimeOfDay _startTime = TimeOfDay.now();
  bool _scheduleVisible = false;
  bool _formVisible = false;
  TextEditingController _datePickerController = TextEditingController();
  String _dateValue = "";
  DateTime _date = DateTime.now();
  String _fieldTypeSelected = "";
  String _userUID = "";
  String _userName = "";
  int _priceSelected = 0;
  bool _isButtonFieldFlooringSelected = false;
  bool _isButtonFieldSynthesisSelected = false;
  String userOrderFlooring;
  String userOrderSynthesis;

  @override
  void initState() {
    _getUserData();
    _onFieldTypeSelected();
    super.initState();
  }

  @override
  void dispose() {
    _datePickerController.dispose();
    _startTimePickerController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime(BuildContext context) async {
    var _timePicker = await showIntervalTimePicker(
      context: context,
      initialTime: _startTime,
      interval: 30,
      visibleStep: VisibleStep.Twentieths,
      helpText:
          'Kami buka jam 9 pagi sampai jam 11 malam.\nMasukkan jam dan menit dahulu, setelah itu tekan ok',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child,
        );
      },
    );

    if (_timePicker != null && _timePicker != _startTime) {
      setState(() {
        _startTime = _timePicker;
        _startTimeValue = _startTime.format(context);
        _startTimePickerController =
            TextEditingController(text: _startTimeValue.replaceAll(':', '.'));
      });
    }
  }

  Future<void> _getUserData() async {
    final _user = await _auth.currentUser();
    var _getUserName = getUserById(_user.uid).then((value) => value.name);
    setState(() {
      _userUID = _user.uid;
      _userName = _getUserName.toString();
    });
  }

  void _onFieldTypeSelected() {
    setState(() {
      if (widget.numberOfFlooring == "0" || userOrderFlooring != null) {
        _isButtonFieldFlooringSelected = false;
        _isButtonFieldSynthesisSelected = true;
        _fieldTypeSelected = "Lapangan Sintesis";
      }
      if (widget.numberOfSynthesis == "0" || userOrderSynthesis != null) {
        _isButtonFieldFlooringSelected = true;
        _isButtonFieldSynthesisSelected = false;
        _fieldTypeSelected = "Lapangan Flooring";
      }
    });
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 100 * 4),
          child: Column(
            children: [
              Text(
                "Lakukan pengecekkan ketersediaan lapangan sebelum memesan!",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 100 * 2,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height / 100 * 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black26,
                    )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Cek Ketersediaan Lapangan",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height / 100 * 2),
                      child: _widgetDateTimeField(context),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100 * 2,
                    ),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      visible: _scheduleVisible,
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 100 * 2,
                          left: MediaQuery.of(context).size.height / 100 * 2,
                          right: MediaQuery.of(context).size.height / 100 * 2,
                        ),
                        child: _widgetFieldScheduleTable(context),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100 * 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 100 * 2,
              ),
              Visibility(
                maintainAnimation: true,
                maintainState: true,
                visible: _formVisible,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tanggal Pesan Lapangan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 100 * 2,
                      ),
                      TextFormField(
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "tentukan tanggal pesan lapangan";
                          }
                          return null;
                        },
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
                            fontSize:
                                MediaQuery.of(context).size.width / 100 * 4,
                            color: kTitleTextColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent[400],
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent[400],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 100 * 2),
                      Text(
                        "Jenis Lapangan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 100 * 1),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width / 100 * 2,
                                ),
                                child: Container(
                                  height: MediaQuery.of(context).size.height /
                                      100 *
                                      6,
                                  child: RaisedButton(
                                    child: Text(
                                      "Lapangan Flooring",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                100 *
                                                3.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    color: (_isButtonFieldFlooringSelected)
                                        ? Colors.greenAccent[400]
                                        : Colors.white,
                                    onPressed:
                                        (widget.numberOfFlooring == "0" ||
                                                userOrderFlooring != null)
                                            ? null
                                            : () {
                                                setState(() {
                                                  _isButtonFieldFlooringSelected =
                                                      true;
                                                  _isButtonFieldSynthesisSelected =
                                                      false;
                                                  _fieldTypeSelected =
                                                      "Lapangan Flooring";
                                                });
                                              },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width / 100 * 3,
                                ),
                                child: Container(
                                  height: MediaQuery.of(context).size.height /
                                      100 *
                                      6,
                                  child: RaisedButton(
                                    child: Text(
                                      "Lapangan Sintesis",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                100 *
                                                3.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    color: (_isButtonFieldSynthesisSelected)
                                        ? Colors.greenAccent[400]
                                        : Colors.white,
                                    onPressed:
                                        (widget.numberOfSynthesis == "0" ||
                                                userOrderSynthesis != null)
                                            ? null
                                            : () {
                                                setState(() {
                                                  _isButtonFieldFlooringSelected =
                                                      false;
                                                  _isButtonFieldSynthesisSelected =
                                                      true;
                                                  _fieldTypeSelected =
                                                      "Lapangan Sintesis";
                                                });
                                              },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 100 * 2),
                      Text(
                        "Pesan Jam",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 100 * 1),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 100 * 7,
                        child: Container(
                          color: Colors.greenAccent[400],
                          child: Center(
                            child: Text(
                              _startTimePickerController.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width /
                                    100 *
                                    5.5,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height / 100 * 25),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 100 * 7,
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height / 100 * 1),
                        child: RaisedButton(
                          child: Text(
                            "Selanjutnya",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.greenAccent[400],
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if (_fieldTypeSelected == "Lapangan Flooring") {
                                switch (_startTimePickerController.text) {
                                  case "09:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "10:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "11:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "12:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "13:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "14:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "15:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "16:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "17:00":
                                    _priceSelected = widget.priceDayFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "18:00":
                                    _priceSelected = widget.priceNightFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "19:00":
                                    _priceSelected = widget.priceNightFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "20:00":
                                    _priceSelected = widget.priceNightFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "21:00":
                                    _priceSelected = widget.priceNightFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "22:00":
                                    _priceSelected = widget.priceNightFlooring;
                                    print(_priceSelected);
                                    break;
                                  case "23:00":
                                    _priceSelected = widget.priceNightFlooring;
                                    print(_priceSelected);
                                    break;
                                  default:
                                    _priceSelected = widget.priceNightFlooring;
                                    print(_priceSelected);
                                }
                              } else {
                                switch (_startTimePickerController.text) {
                                  case "09:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "10:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "11:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "12:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "13:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "14:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "15:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "16:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "17:00":
                                    _priceSelected = widget.priceDaySynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "18:00":
                                    _priceSelected = widget.priceNightSynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "19:00":
                                    _priceSelected = widget.priceNightSynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "20:00":
                                    _priceSelected = widget.priceNightSynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "21:00":
                                    _priceSelected = widget.priceNightSynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "22:00":
                                    _priceSelected = widget.priceNightSynthesis;
                                    print(_priceSelected);
                                    break;
                                  case "23:00":
                                    _priceSelected = widget.priceNightSynthesis;
                                    print(_priceSelected);
                                    break;
                                  default:
                                    _priceSelected = widget.priceNightSynthesis;
                                    print(_priceSelected);
                                }
                              }

                              ExtendedNavigator.ofRouter<router_gr.Router>()
                                  .pushNamed(
                                router_gr.Routes.invoiceScreen,
                                arguments: router_gr.InvoiceScreenArguments(
                                  uid: widget.uid,
                                  userUID: _userUID,
                                  userName: _userName,
                                  futsalFieldPhone: widget.phone,
                                  timeOrderSelected:
                                      _startTimePickerController.text,
                                  fieldTypeSelected: _fieldTypeSelected,
                                  fieldPrice: _priceSelected,
                                  fieldName: widget.name,
                                  dateOrderSelected: _datePickerController.text,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _widgetFieldScheduleTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tanggal Pesan ${_datePickerController.text}',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: MediaQuery.of(context).size.height / 100 * 1.8,
          ),
        ),
        Text(
          'Lapangan Dipesan untuk Jam : ${_startTimePickerController.text}',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: MediaQuery.of(context).size.height / 100 * 1.8,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            dividerThickness: 1.0,
            headingTextStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.height / 100 * 1.8,
            ),
            columns: [
              DataColumn(
                label: Text('Lapangan Flooring'),
              ),
              DataColumn(
                label: Text('Lapangan Sintetis'),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(
                  (userOrderFlooring != null)
                      ? Center(child: Text(userOrderFlooring))
                      : Center(child: Text('Tersedia')),
                ),
                DataCell(
                  (userOrderSynthesis != null)
                      ? Center(child: Text(userOrderSynthesis))
                      : Center(child: Text('Tersedia')),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Form _widgetDateTimeField(BuildContext context) {
    return Form(
      key: _checkFormKey,
      child: Column(
        children: [
          // select date schedule
          TextFormField(
            validator: (String value) {
              if (value.isEmpty) {
                return 'tentukan tanggal pesan lapangan';
              }
              return null;
            },
            onTap: () {
              setState(() {
                _selectDate(context);
              });
            },
            controller: _datePickerController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: '$_dateValue',
              labelText: 'Pilih Tanggal',
              labelStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 4,
                color: Colors.black54,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 100 * 1.5,
          ),
          // select start time schedule
          TextFormField(
            validator: (String value) {
              if (value.isEmpty) {
                return 'tentukan jam mulai pesan lapangan';
              }
              return null;
            },
            onTap: () {
              setState(() {
                _selectStartTime(context);
              });
            },
            controller: _startTimePickerController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: '$_startTimeValue',
              labelText: 'Pilih Jam Mulai',
              labelStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 4,
                color: Colors.black54,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 100 * 1.5,
          ),
          // select finish time schedule

          // button submit
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 100 * 5,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  userOrderFlooring = null;
                  userOrderSynthesis = null;
                });

                if (_formKey.currentState.validate()) {
                  getScheduleData(widget.uid, _datePickerController.text,
                          _startTimePickerController.text)
                      .then((value) {
                    value.documents.forEach((element) {
                      var schedule = Schedule.fromMap(element.data);

                      switch (schedule.fieldType) {
                        case 'Lapangan Flooring':
                          setState(() {
                            userOrderFlooring = schedule.bookBy;
                          });
                          print('LOG:     $userOrderFlooring');
                          break;
                        case 'Lapangan Sintesis':
                          setState(() {
                            userOrderSynthesis = schedule.bookBy;
                          });
                          print('LOG:     $userOrderSynthesis');
                          break;
                        default:
                          print('nope');
                      }
                    });
                  });

                  setState(() {
                    _scheduleVisible = true;
                    _formVisible = true;
                  });
                }
              },
              child: Text('Tampil Data'),
            ),
          ),
        ],
      ),
    );
  }
}
