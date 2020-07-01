import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:map_launcher/map_launcher.dart';

final Firestore _fireStore = Firestore.instance;

class FutsalFieldInformation extends StatefulWidget {
  final String uid;

  const FutsalFieldInformation({@required this.uid});

  @override
  _FutsalFieldInformationState createState() => _FutsalFieldInformationState();
}

class _FutsalFieldInformationState extends State<FutsalFieldInformation> {
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  
  Position _currentPosition = Position(latitude: 0.0, longitude: 0.0);
  String _uid = "-";
  String _imageUrl = "-";
  String _name = "-";
  GeoPoint _location = GeoPoint(0.0, 0.0);
  String _address = "-";
  String _phone = "-";
  String _closingHour = "-";
  String _openingHour = "-";

  @override
  void initState() {
    _getCurrentLocation();
    _getFutsalFieldData();
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
      _uid = _data.data['uid'];
      _imageUrl = _data.data['image'];
      _name = _data.data['name'];
      _location = _data.data['location'];
      _address = _data.data["address"];
      _phone = _data.data["phone"];
      _closingHour = _data.data["closingHours"];
      _openingHour = _data.data["openingHours"];
    });
  }

  Future<void> _getCurrentLocation() async {
    // get current device location
    await geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
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
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Center(
                    child: FaIcon(
                      FontAwesomeIcons.exclamationTriangle,
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
                                                  "2 KM",
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
                                                  "1",
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
                                                  "2",
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
                      color: kLogoLightGreenColor,
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
