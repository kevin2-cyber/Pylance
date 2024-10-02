import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleMap extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const ShuttleMap({super.key, required this.initialLatitude, required this.initialLongitude});

  @override
  State<ShuttleMap> createState() => _ShuttleMapState();
}

class _ShuttleMapState extends State<ShuttleMap> {
  late GoogleMapController mapController;
  late LatLng currentLocation;

  @override
  void initState() {
    super.initState();
    currentLocation = LatLng(widget.initialLatitude, widget.initialLongitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: currentLocation,
        zoom: 14.0,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('shuttle'),
          position: currentLocation,
        ),
      },
    );
  }
}
