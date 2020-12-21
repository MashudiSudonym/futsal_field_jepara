import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/model/data.dart';
import 'package:futsal_field_jepara/model/field_type.dart';
import 'package:futsal_field_jepara/model/futsal_field.dart';
import 'package:futsal_field_jepara/model/schedule.dart';
import 'package:futsal_field_jepara/utils/currency_formatter.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart' as router_gr;
import 'package:geolocator/geolocator.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';

class FutsalFieldInformation extends StatefulWidget {
  final String uid;

  const FutsalFieldInformation({@required this.uid});

  @override
  _FutsalFieldInformationState createState() => _FutsalFieldInformationState();
}

class _FutsalFieldInformationState extends State<FutsalFieldInformation> {
  final Geolocator _geoLocator = Geolocator()..forceAndroidLocationManager;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _datePickerController = TextEditingController();
  String _dateValue = '';
  DateTime _date = DateTime.now();
  TextEditingController _startTimePickerController = TextEditingController();
  String _startTimeValue = '';
  TimeOfDay _startTime = TimeOfDay.now();
  bool visible = false;
  Position _currentPosition = Position(latitude: 0.0, longitude: 0.0);
  double _distance = 0.0;
  String _resultDistance = "-";
  String _imageUrl = "-";
  String _name = "-";
  GeoPoint _location = GeoPoint(0.0, 0.0);
  String _address = "-";
  String _phone = "-";
  String _closingHour = "-";
  String _openingHour = "-";
  String _fieldTypeFlooring = "-";
  String _fieldTypeSynthesis = "-";
  String _numberOfFlooring = "-";
  String _numberOfSynthesis = "-";
  int _priceDayFlooring = 0;
  int _priceNightFlooring = 0;
  int _priceDaySynthesis = 0;
  int _priceNightSynthesis = 0;
  String userOrderFlooring;
  String userOrderSynthesis;

  @override
  void initState() {
    _getFutsalFieldData();
    _getFieldTypeData();
    _getCurrentLocationAndDistance();
    super.initState();
  }

  @override
  void dispose() {
    _datePickerController.dispose();
    _startTimePickerController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    var _datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1945),
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

  Future<void> _selectStartTime(BuildContext context) async {
    var _timePicker = await showIntervalTimePicker(
      context: context,
      initialTime: _startTime,
      interval: 30,
      visibleStep: VisibleStep.Twentieths,
      helpText: 'Masukkan jam dan menit dahulu, setelah itu tekan ok',
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

  Future<void> _getFutsalFieldData() async {
    await getFutsalFieldById(widget.uid).then((FutsalFields futsalField) {
      setState(() {
        _imageUrl = futsalField.image;
        _name = futsalField.name;
        _location = futsalField.location;
        _address = futsalField.address;
        _phone = futsalField.phone;
        _closingHour = futsalField.closingHours;
        _openingHour = futsalField.openingHours;
        _fieldTypeFlooring = futsalField.fieldTypeFlooring;
        _fieldTypeSynthesis = futsalField.fieldTypeSynthesis;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _getFieldTypeData() async {
    Timer(Duration(seconds: 2), () async {
      // flooring field data
      await getFieldTypeData(_fieldTypeFlooring).then((FieldType fieldType) {
        setState(() {
          _numberOfFlooring = fieldType.numberOfField.toString();
          _priceDayFlooring = fieldType.priceDay;
          _priceNightFlooring = fieldType.priceNight;
        });
      }).catchError((e) {
        print(e);
      });
      // synthesis field data
      await getFieldTypeData(_fieldTypeSynthesis).then((FieldType fieldType) {
        setState(() {
          _numberOfSynthesis = fieldType.numberOfField.toString();
          _priceDaySynthesis = fieldType.priceDay;
          _priceNightSynthesis = fieldType.priceNight;
        });
      }).catchError((e) {
        print(e);
      });
    });
  }

  Future<void> _getCurrentLocationAndDistance() async {
    Timer(Duration(seconds: 1), () async {
      await _geoLocator
          .getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
      }).catchError((e) {
        print(e);
      });

      await _geoLocator
          .distanceBetween(
              _currentPosition.latitude,
              _currentPosition.longitude,
              _location.latitude,
              _location.longitude)
          .then((value) {
        setState(() {
          _distance = value;
          _resultDistance = (_distance / 1000).toStringAsFixed(1);
        });
      }).catchError((e) {
        print(e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 100 * 35,
              child: Hero(
                tag: widget.uid,
                child: CachedNetworkImage(
                  imageUrl: _imageUrl,
                  placeholder: (context, url) => Center(
                    child: Lottie.asset(
                      "assets/loading.json",
                      height: MediaQuery.of(context).size.height / 100 * 10,
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Lottie.asset(
                      "assets/error.json",
                      height: MediaQuery.of(context).size.height / 100 * 10,
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 100 * 4,
                MediaQuery.of(context).size.width / 100,
                MediaQuery.of(context).size.width / 100 * 4,
                MediaQuery.of(context).size.height / 100 * 4,
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 100 * 4,
                        ),
                        margin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 100 * 4,
                          MediaQuery.of(context).size.height / 100 * 25,
                          MediaQuery.of(context).size.width / 100 * 4,
                          MediaQuery.of(context).size.height / 100 * 4,
                        ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width / 100 * 4,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          100 *
                                          1,
                                    ),
                                    child: Text(
                                      _name,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                100 *
                                                6,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          100 *
                                          1,
                                      bottom:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              1,
                                    ),
                                    child: Text(
                                      _address,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                100 *
                                                3,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              1,
                                    ),
                                    child: SelectableText(
                                      _phone,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                100 *
                                                3,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        100 *
                                        3,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100 *
                                                    1,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "$_resultDistance KM",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100 *
                                                    1,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Jarak dari Lokasi Anda",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100 *
                                                    1,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  _numberOfFlooring,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100 *
                                                    1,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Lapangan Flooring",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100 *
                                                    1,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  _numberOfSynthesis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100 *
                                                    1,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Lapangan Sintetis",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100 * 1,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.height / 100 * 2),
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
                          visible: visible,
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height / 100 * 2,
                              left:
                                  MediaQuery.of(context).size.height / 100 * 2,
                              right:
                                  MediaQuery.of(context).size.height / 100 * 2,
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
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.height / 100 * 2),
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
                            "Jam Operasional",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 100 * 4,
                            0,
                            MediaQuery.of(context).size.width / 100 * 4,
                            MediaQuery.of(context).size.width / 100 * 4,
                          ),
                          child: Table(
                            columnWidths: {
                              0: FractionColumnWidth(.2),
                              1: FractionColumnWidth(.1),
                              2: FractionColumnWidth(.8)
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Text("Senin"),
                                  ),
                                  TableCell(
                                    child: Text(":"),
                                  ),
                                  TableCell(
                                    child:
                                        Text("$_openingHour - $_closingHour"),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Text("Selasa"),
                                  ),
                                  TableCell(
                                    child: Text(":"),
                                  ),
                                  TableCell(
                                    child:
                                        Text("$_openingHour - $_closingHour"),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Text("Rabu"),
                                  ),
                                  TableCell(
                                    child: Text(":"),
                                  ),
                                  TableCell(
                                    child:
                                        Text("$_openingHour - $_closingHour"),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Text("Kamis"),
                                  ),
                                  TableCell(
                                    child: Text(":"),
                                  ),
                                  TableCell(
                                    child:
                                        Text("$_openingHour - $_closingHour"),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Text("Jumat"),
                                  ),
                                  TableCell(
                                    child: Text(":"),
                                  ),
                                  TableCell(
                                    child:
                                        Text("$_openingHour - $_closingHour"),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Text("Sabtu"),
                                  ),
                                  TableCell(
                                    child: Text(":"),
                                  ),
                                  TableCell(
                                    child:
                                        Text("$_openingHour - $_closingHour"),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Text("Minggu"),
                                  ),
                                  TableCell(
                                    child: Text(":"),
                                  ),
                                  TableCell(
                                    child:
                                        Text("$_openingHour - $_closingHour"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100 * 2,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.height / 100 * 2),
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
                            "Daftar Harga",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Divider(),
                        DataTable(
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text(
                                "",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Flooring",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Synthesis",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    "Pagi",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              3,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    (_priceDayFlooring == 0)
                                        ? '-'
                                        : currencyFormatter(_priceDayFlooring),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              3,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    (_priceDaySynthesis == 0)
                                        ? '-'
                                        : currencyFormatter(_priceDaySynthesis),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    "Malam",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              3,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    (_priceNightFlooring == 0)
                                        ? '-'
                                        : currencyFormatter(
                                            _priceNightFlooring),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              3,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    (_priceNightSynthesis == 0)
                                        ? '-'
                                        : currencyFormatter(
                                            _priceNightSynthesis),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100 * 2,
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 100 * 7,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 100 * 1),
                    child: RaisedButton(
                      child: Text(
                        "Pesan Lapangan",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.greenAccent[400],
                      onPressed: (_numberOfSynthesis == "-")
                          ? null
                          : () {
                              ExtendedNavigator.ofRouter<router_gr.Router>()
                                  .pushNamed(
                                router_gr.Routes.createSchedule,
                                arguments: router_gr.CreateScheduleArguments(
                                  uid: widget.uid,
                                  name: _name,
                                  phone: _phone,
                                  numberOfFlooring: _numberOfFlooring,
                                  numberOfSynthesis: _numberOfSynthesis,
                                  priceDayFlooring: _priceDayFlooring,
                                  priceNightFlooring: _priceNightFlooring,
                                  priceDaySynthesis: _priceDaySynthesis,
                                  priceNightSynthesis: _priceNightSynthesis,
                                ),
                              );
                            },
                    ),
                  ),
                ],
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width / 100 * 2),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 100 * 5,
                    ),
                    onPressed: () {
                      ExtendedNavigator.of(context).pop();
                    },
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width / 100 * 2),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Center(
                        child: FaIcon(
                          FontAwesomeIcons.mapMarkedAlt,
                          size: MediaQuery.of(context).size.width / 100 * 4,
                          color: Colors.black87,
                        ),
                      ),
                      onPressed: () async {
                        final availableMap = await MapLauncher.installedMaps;
                        await availableMap.first.showMarker(
                          coords:
                              Coords(_location.latitude, _location.longitude),
                          title: _name,
                          description: "Location of $_name",
                        );
                      },
                    ),
                  ),
                ),
              ],
              elevation: 0,
            ),
          ],
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
      key: _formKey,
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
                    visible = true;
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
