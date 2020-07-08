import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/currency_formater.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';

final Firestore _fireStore = Firestore.instance;

class FutsalFieldInformation extends StatefulWidget {
  final String uid;

  const FutsalFieldInformation({@required this.uid});

  @override
  _FutsalFieldInformationState createState() => _FutsalFieldInformationState();
}

class _FutsalFieldInformationState extends State<FutsalFieldInformation> {
  final Geolocator _geoLocator = Geolocator()..forceAndroidLocationManager;

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

  @override
  void initState() {
    _getFutsalFieldData();
    _getCurrentLocationAndDistance();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getFutsalFieldData() async {
    final _data =
        await _fireStore.collection("futsalFields").document(widget.uid).get();

    setState(() {
      _imageUrl = _data.data['image'];
      _name = _data.data['name'];
      _location = _data.data['location'];
      _address = _data.data["address"];
      _phone = _data.data["phone"];
      _closingHour = _data.data["closingHours"];
      _openingHour = _data.data["openingHours"];
      _fieldTypeFlooring = _data.data["fieldTypeFlooring"];
      _fieldTypeSynthesis = _data.data["fieldTypeSynthesis"];
    });

    final _dataFieldFlooring =
        await _fireStore.document(_fieldTypeFlooring).get();
    final _dataFieldSynthesis =
        await _fireStore.document(_fieldTypeSynthesis).get();

    setState(() {
      _numberOfFlooring = _dataFieldFlooring['numberOfField'].toString();
      _numberOfSynthesis = _dataFieldSynthesis['numberOfField'].toString();
      _priceDayFlooring = _dataFieldFlooring['priceDay'];
      _priceNightFlooring = _dataFieldFlooring['priceNight'];
      _priceDaySynthesis = _dataFieldSynthesis['priceDay'];
      _priceNightSynthesis = _dataFieldSynthesis['priceNight'];
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
                                                  "Lapangan Flooring",
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
                          title: Text("Jam Operasional"),
                        ),
                        Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width /
                                    100 *
                                    4.5,
                                bottom: MediaQuery.of(context).size.height /
                                    100 *
                                    1,
                              ),
                              child:
                                  Text("Senin : $_openingHour - $_closingHour"),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width /
                                    100 *
                                    4.5,
                                bottom: MediaQuery.of(context).size.height /
                                    100 *
                                    1,
                              ),
                              child: Text(
                                  "Selasa : $_openingHour - $_closingHour"),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width /
                                    100 *
                                    4.5,
                                bottom: MediaQuery.of(context).size.height /
                                    100 *
                                    1,
                              ),
                              child:
                                  Text("Rabu : $_openingHour - $_closingHour"),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width /
                                    100 *
                                    4.5,
                                bottom: MediaQuery.of(context).size.height /
                                    100 *
                                    1,
                              ),
                              child:
                                  Text("Kamis : $_openingHour - $_closingHour"),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width /
                                    100 *
                                    4.5,
                                bottom: MediaQuery.of(context).size.height /
                                    100 *
                                    1,
                              ),
                              child:
                                  Text("Jumat : $_openingHour - $_closingHour"),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width /
                                    100 *
                                    4.5,
                                bottom: MediaQuery.of(context).size.height /
                                    100 *
                                    1,
                              ),
                              child:
                                  Text("Sabtu : $_openingHour - $_closingHour"),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width /
                                    100 *
                                    4.5,
                                bottom: MediaQuery.of(context).size.height /
                                    100 *
                                    1,
                              ),
                              child: Text(
                                  "Minggu : $_openingHour - $_closingHour"),
                            )
                          ],
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
                          title: Text("Daftar Harga"),
                        ),
                        Divider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 100 * 2,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Flooring",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Synthesis",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 100 * 2,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        100 *
                                        2,
                                  ),
                                  Text(
                                    "Pagi",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(flex: 2),
                                  Text(
                                    (_priceDayFlooring == 0)
                                        ? '-'
                                        : currencyFormater(_priceDayFlooring),
                                  ),
                                  Spacer(flex: 4),
                                  Text(
                                    (_priceDaySynthesis == 0)
                                        ? '-'
                                        : currencyFormater(_priceDaySynthesis),
                                  ),
                                  Spacer(flex: 3),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 100 * 2,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        100 *
                                        2,
                                  ),
                                  Text(
                                    "Malam",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(flex: 1),
                                  Text(
                                    (_priceNightFlooring == 0)
                                        ? '-'
                                        : currencyFormater(_priceNightFlooring),
                                  ),
                                  Spacer(flex: 4),
                                  Text(
                                    (_priceNightSynthesis == 0)
                                        ? '-'
                                        : currencyFormater(
                                            _priceNightSynthesis),
                                  ),
                                  Spacer(flex: 3),
                                ],
                              ),
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
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.greenAccent[400],
                      onPressed: () {},
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
}
