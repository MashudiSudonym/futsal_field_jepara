import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

final Firestore _fireStore = Firestore.instance;

class CreateSchedule extends StatefulWidget {
  final String uid;

  const CreateSchedule({@required this.uid});

  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  TextEditingController _datePickerController = TextEditingController();
  String _dateValue = "";
  DateTime _date = DateTime.now();
  List<String> _fieldTypeList = [
    "Lapangan Flooring",
    "Lapangan Sintetis",
  ];
  List<String> _timeOrderList = [
    "09.00",
    "10.00",
    "12.00",
    "13.00",
    "14.00",
    "15.00",
    "16.00",
    "17.00",
    "18.00",
    "19.00",
    "20.00",
    "21.00",
    "22.00",
    "23.00",
  ];
  int _fieldTypeSelectedIndex = 0;
  int _timeOrderSelectedIndex = 0;
  String _fieldTypeSelected = "";
  String _timeOrderSelected = "";

  @override
  void initState() {
    _onFieldTypeSelected(0);
    _onTimeOrderSelected(0);
    super.initState();
  }

  @override
  void dispose() {
    _datePickerController.dispose();
    super.dispose();
  }

  void _onFieldTypeSelected(int index) {
    setState(() {
      _fieldTypeSelectedIndex = index;
      _fieldTypeSelected = _fieldTypeList[index];
    });
  }

  void _onTimeOrderSelected(int index) {
    setState(() {
      _timeOrderSelectedIndex = index;
      _timeOrderSelected = _timeOrderList[index];
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
              SizedBox(height: MediaQuery.of(context).size.height / 100 * 2),
              Text(
                "Jenis Lapangan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100 * 1),
              SizedBox(
                height: MediaQuery.of(context).size.height / 100 * 8,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing:
                        MediaQuery.of(context).size.width / 100 * 2,
                    mainAxisSpacing: 2,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _fieldTypeList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: (_fieldTypeSelectedIndex != null &&
                              _fieldTypeSelectedIndex == index)
                          ? Colors.greenAccent[400]
                          : kPrimaryColor,
                      child: ListTile(
                        title: Text(
                          _fieldTypeList[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: (_fieldTypeSelectedIndex != null &&
                                    _fieldTypeSelectedIndex == index)
                                ? kPrimaryColor
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _onFieldTypeSelected(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100 * 2),
              Text(
                "Pesan Jam",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100 * 1),
              SizedBox(
                height: MediaQuery.of(context).size.height / 100 * 28,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 16 / 9,
                    mainAxisSpacing: 2,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _timeOrderList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: (_timeOrderSelectedIndex != null &&
                              _timeOrderSelectedIndex == index)
                          ? Colors.greenAccent[400]
                          : kPrimaryColor,
                      child: Center(
                        child: ListTile(
                          title: Text(
                            _timeOrderList[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: (_timeOrderSelectedIndex != null &&
                                      _timeOrderSelectedIndex == index)
                                  ? kPrimaryColor
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _onTimeOrderSelected(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100 * 25),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 100 * 7,
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.height / 100 * 1),
                child: RaisedButton(
                  child: Text(
                    "Selanjutnya",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.greenAccent[400],
                  onPressed: () {
                    print("Berikutnya");
                    print(_fieldTypeSelected);
                    print(_timeOrderSelected);
                    print(_datePickerController.text);
                    print(widget.uid);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
