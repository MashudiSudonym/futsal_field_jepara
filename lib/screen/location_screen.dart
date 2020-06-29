import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:futsal_field_jepara/model/futsal_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final Firestore _fireStore = Firestore.instance;

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final mainRoot = _fireStore.collection("futsalFields");
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  final _defaultPosition = CameraPosition(
    target: LatLng(-6.649179, 110.707172),
    zoom: 18.0,
  );
  Position _currentPosition;
  GoogleMapController googleMapController;
  Set<Marker> _markers = Set();
  Marker _marker;

  @override
  void initState() {
    _getCurrentLocation();
    _futsalFieldMarker();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  Future<void> _futsalFieldMarker() async {
    setState(() {
      mainRoot.snapshots().listen((snapshot) {
        snapshot.documents.map((data) {
          final futsalFields = FutsalFields.fromSnapshot(data);

          _marker = Marker(
            flat: true,
            markerId: MarkerId("${futsalFields.uid}"),
            position: LatLng(futsalFields.location.latitude,
                futsalFields.location.longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: "${futsalFields.name.toUpperCase()}",
              snippet: "${futsalFields.address.toUpperCase()}",
              onTap: () {
                print(futsalFields.uid);
              },
            ),
          );

          _markers.add(_marker);
        }).toList();
      });
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
