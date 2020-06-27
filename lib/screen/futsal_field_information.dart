import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/widget/sliver_app_bar_custom.dart';
import 'package:geolocator/geolocator.dart';

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
  String _imageUrl = "-";
  String _name = "-";
  GeoPoint _location = GeoPoint(0.0, 0.0);

  @override
  void initState() {
    _getCurrentLocation();
    _getFutsalFieldData();
    super.initState();
  }

  Future<void> _getFutsalFieldData() async {
    final _data =
        await _fireStore.collection("futsalFields").document(widget.uid).get();

    setState(() {
      _imageUrl = _data.data['image'];
      _name = _data.data['name'];
      _location = _data.data['location'];
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
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScroll) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: SliverAppBarCustom(
                maxExtend: MediaQuery.of(context).size.height / 100 * 35,
                minExtend: MediaQuery.of(context).size.height / 100 * 10,
                imageUrl: (_imageUrl != "-")
                    ? _imageUrl
                    : "https://firebasestorage.googleapis.com/v0/b/futsal-field-jepara.appspot.com/o/other%2FSpinner-1s-200px.gif?alt=media&token=6b9ffe59-a10c-48fd-b420-17a102a0f4de",
                title: _name,
                uid: widget.uid,
                location: _location,
              ),
              pinned: true,
              floating: false,
            ),
          ];
        },
        body: Center(
          child: Text("${_location.latitude}, ${_location.longitude}, my location ${_currentPosition.latitude}, ${_currentPosition.longitude}"),
        ),
      ),
    );
  }
}
