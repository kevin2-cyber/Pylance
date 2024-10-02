import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleProvider with ChangeNotifier {
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;

  LatLng? get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;

  // Method to start tracking location
  void startTracking() {
    _isTracking = true;
    _positionStream = Geolocator.getPositionStream().listen((Position position) {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _updateLocationInFirestore(position);
      notifyListeners();
    });
  }

  // Method to stop tracking location and save the trip with a destination name
  Future<void> stopTracking(BuildContext context) async {
    _isTracking = false;
    _positionStream?.cancel();
    notifyListeners();

    // Prompt user to input destination name
    String? destination = await _showDestinationDialog(context);

    if (destination != null && destination.isNotEmpty) {
      await _saveTrip(destination);
    }
  }

  // Private method to update shuttle location in Firestore
  void _updateLocationInFirestore(Position position) {
    FirebaseFirestore.instance.collection('shuttles').doc('shuttle_1').set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Method to save the completed trip with timestamp and destination in Firestore
  Future<void> _saveTrip(String destination) async {
    await FirebaseFirestore.instance.collection('trips').add({
      'shuttle_id': 'shuttle_1',
      'destination': destination,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Method to show a dialog to enter the destination name
  Future<String?> _showDestinationDialog(BuildContext context) async {
    String? destination;
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Destination'),
          content: TextField(
            onChanged: (value) {
              destination = value;
            },
            decoration: const InputDecoration(hintText: "Destination Name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(destination);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fetch trips from Firestore
  Stream<QuerySnapshot> fetchTrips() {
    return FirebaseFirestore.instance.collection('trips').snapshots();
  }
}

