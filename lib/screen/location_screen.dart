import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  Completer<GoogleMapController> _controller = Completer();
  static final _defaultPosition = CameraPosition(
    target: LatLng(-6.649179, 110.707172),
    zoom: 18.0,
  );
  Set<Marker> _markers = Set();
  Marker _marker = Marker(
    markerId: MarkerId("my location"),
    position: LatLng(-6.649179, 110.707172),
  );

  @override
  void initState() {
    _getCurrentLocation();
    _markers.add(_marker);
    super.initState();
  }

  void _getCurrentLocation() async {
    await geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });

    _goToMyLocation();
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;

    setState(() {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: (_currentPosition != null)
                ? LatLng(_currentPosition.latitude, _currentPosition.longitude)
                : LatLng(-6.649179, 110.707172),
            zoom: 18.0,
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
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
        },
      ),
    );
  }
}
