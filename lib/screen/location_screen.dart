import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:futsal_field_jepara/model/data.dart';
import 'package:futsal_field_jepara/model/futsal_field.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart' as router_gr;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  final _defaultPosition = CameraPosition(
    target: LatLng(-6.649179, 110.707172),
    zoom: 18.0,
  );
  Position _currentPosition;
  GoogleMapController googleMapController;
  Set<Marker> _markers = Set();
  Marker _marker;
  StreamSubscription<QuerySnapshot> _currentSubscription;
  List<FutsalFields> _futsalFields = <FutsalFields>[];

  @override
  void initState() {
    _currentSubscription = loadAllFutsalFields().listen(_getFutsalFields);
    _getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    _currentSubscription.cancel();
    super.dispose();
  }

  void _getFutsalFields(QuerySnapshot snapshot) {
    setState(() {
      _futsalFields = getAllFutsalFields(snapshot);
      _futsalFields.forEach((element) {
        _marker = Marker(
          flat: true,
          markerId: MarkerId("${element.uid}"),
          position:
              LatLng(element.location.latitude, element.location.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: "${element.name.toUpperCase()}",
            snippet: "${element.address.toUpperCase()}",
            onTap: () {
              ExtendedNavigator.ofRouter<router_gr.Router>().pushNamed(
                router_gr.Routes.futsalFieldInformation,
                arguments:
                    router_gr.FutsalFieldInformationArguments(uid: element.uid),
              );
            },
          ),
        );

        _markers.add(_marker);
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      googleMapController = controller;
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

    // set center map to device location
    _goToMyLocation();
  }

  Future<void> _goToMyLocation() async {
    setState(() {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: (_currentPosition != null)
                ? LatLng(_currentPosition.latitude, _currentPosition.longitude)
                : LatLng(-6.649179, 110.707172),
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // status bar and navigation bar colors
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _defaultPosition,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 100 * 6),
        markers: _markers,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
