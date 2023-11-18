import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_dotenv/flutter_dotenv.dart' as Dotenv;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Location location = Location();
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};
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
      await dotenv.load();
      final currentLocation = await location.getLocation();
      const LatLng destination = LatLng(-1.2560436592076922, 116.8360665);

      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('current'),
            position: LatLng(
              currentLocation.latitude ?? 0.0,
              currentLocation.longitude ?? 0.0,
            ),
            infoWindow: const InfoWindow(
              title: 'Current Location',
            ),
          ),
        );
        _markers.add(
          const Marker(
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
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? "";

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    setState(() {
      _polylines.add(
        Polyline(
          width: 5,
          polylineId: const PolylineId('polyline'),
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
          const LatLng destination = LatLng(-1.2560436592076922, 116.8360665);
          _openGoogleMaps(destination);
        },
        label: const Text('Petunjuk Arah'),
        icon: const Icon(Icons.directions),
      ),
    );
  }
}
