import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttle_tracker/auth_provider.dart';
import 'package:shuttle_tracker/login_screen.dart';
import 'shuttle_provider.dart';

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    final shuttleProvider = Provider.of<ShuttleProvider>(context);
    final authProvider = Provider.of<AuthenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Home'),
        actions: [
          IconButton(
              onPressed: () {
                authProvider.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout)
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: shuttleProvider.currentLocation ?? const LatLng(37.4219983, -122.084),
                zoom: 14,
              ),
              markers: {
                if (shuttleProvider.currentLocation != null)
                  Marker(
                    markerId: const MarkerId('shuttle'),
                    position: shuttleProvider.currentLocation!,
                    infoWindow: const InfoWindow(title: 'Shuttle Location'),
                  ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Start and Stop buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: shuttleProvider.isTracking
                          ? null
                          : () {
                        shuttleProvider.startTracking();
                      },
                      child: const Text('Start Tracking'),
                    ),
                    ElevatedButton(
                      onPressed: !shuttleProvider.isTracking
                          ? null
                          : () async {
                        await shuttleProvider.stopTracking(context);
                      },
                      child: const Text('Stop Tracking'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Completed Trips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Display completed trips in ListView
                StreamBuilder<QuerySnapshot>(
                  stream: shuttleProvider.fetchTrips(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final trips = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          Map<String, dynamic> tripData = trip.data() as Map<String, dynamic>;

                          // Check if the "destination" field exists
                          String destination = tripData.containsKey('destination')
                              ? tripData['destination']
                              : 'Unknown Destination';

                          Timestamp timestamp = tripData['timestamp'];
                          DateTime dateTime = timestamp.toDate();
                          return ListTile(
                            title: Text('Trip ${index + 1} to $destination'),
                            subtitle: Text('Completed on: ${dateTime.toString()}'),
                          );
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
