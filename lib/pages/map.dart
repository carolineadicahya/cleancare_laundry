import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Location location = Location();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.2921, 116.8385),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    try {
      final currentLocation = await location.getLocation();
      final LatLng destination = LatLng(-1.2560436592076922, 116.8360665);

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('current'),
            position: LatLng(
              currentLocation.latitude ?? 0.0,
              currentLocation.longitude ?? 0.0,
            ),
            infoWindow: InfoWindow(
              title: 'Current Location',
            ),
          ),
        );
        _markers.add(
          Marker(
            markerId: MarkerId('destination'),
            position: destination,
            infoWindow: InfoWindow(
              title: 'Destination',
            ),
          ),
        );

        _setPolylines(
          LatLng(
            currentLocation.latitude ?? 0.0,
            currentLocation.longitude ?? 0.0,
          ),
          destination,
        );
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentLocation.latitude ?? 0.0,
            currentLocation.longitude ?? 0.0,
          ),
          zoom: 14.0,
        ),
      ));
    } catch (e) {
      print('Error: $e');
    }
  }

  void _setPolylines(LatLng origin, LatLng destination) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAeqrAND55gTmvw_-rU_kWW6TigGwy__vE',
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      _polylines.add(
        Polyline(
          width: 5,
          polylineId: PolylineId('polyline'),
          color: Colors.blue,
          points: polylineCoordinates,
        ),
      );
    });
  }

  Future<void> _openGoogleMaps(LatLng destination) async {
    final uri = Uri.https('www.google.com', 'maps/dir/', {
      'api': '1',
      'destination': '${destination.latitude},${destination.longitude}',
    });
    final url = uri.toString();
    if (await UrlLauncher.canLaunch(url)) {
      await UrlLauncher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        polylines: _polylines,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final LatLng destination = LatLng(-1.2560436592076922, 116.8360665);
          _openGoogleMaps(destination);
        },
        label: const Text('Petunjuk Arah'),
        icon: const Icon(Icons.directions),
      ),
    );
  }
}
