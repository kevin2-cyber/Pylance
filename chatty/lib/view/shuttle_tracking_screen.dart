import 'package:chatty/provider/shuttle_location_provider.dart';
import 'package:chatty/view/shuttle_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/models.dart';
import '../service/api_service.dart';

class ShuttleTrackingScreen extends StatefulWidget {
  final int shuttleId;

  const ShuttleTrackingScreen({super.key, required this.shuttleId});

  @override
  State<ShuttleTrackingScreen> createState() => _ShuttleTrackingScreenState();
}

class _ShuttleTrackingScreenState extends State<ShuttleTrackingScreen> {
  final ApiService apiService = ApiService();
  late ShuttleLocation currentLocation;

  @override
  void initState() {
    super.initState();
    // Fetch shuttle location when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShuttleLocationProvider>(context, listen: false)
          .fetchShuttleRoutes(widget.shuttleId);
    });
    // _fetchShuttleLocation();
  }

  // void _fetchShuttleLocation() async {
  //   try {
  //     List<ShuttleLocation> history = await apiService.getShuttleHistory(widget.shuttleId);
  //     setState(() {
  //       currentLocation = history.last; // Show the latest location
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error fetching shuttle location: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final shuttleLocationProvider =
        Provider.of<ShuttleLocationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shuttle Tracking'),
        centerTitle: true,
      ),
      body: shuttleLocationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : shuttleLocationProvider.errorMessage != null
              ? Center(child: Text(shuttleLocationProvider.errorMessage!))
              : Column(children: [
                  Expanded(
                    child: shuttleLocationProvider.currentLocation != null
                        ? ShuttleMap(
                            initialLatitude: shuttleLocationProvider
                                .currentLocation!.latitude,
                            initialLongitude: shuttleLocationProvider
                                .currentLocation!.longitude,
                          )
                        : const Center(child: Text("No location data")),
                  ),
                  if (!shuttleLocationProvider.isOnRoute)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Shuttle has deviated from the route!',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
        ElevatedButton(
          onPressed: () {
            // Simulate a location update
            ShuttleLocation newLocation = ShuttleLocation(
              latitude: 37.7749,
              longitude: -122.4194,
              timestamp: DateTime.now(),
            );
            shuttleLocationProvider.updateShuttleLocation(widget.shuttleId, newLocation);
          },
          child: const Text("Update Location"),
        ),
                ]),
    );
  }
}
