import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttle_tracker/login_screen.dart';
import 'auth_provider.dart';
import 'shuttle_provider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  // This will store the list of favorite trip IDs
  Set<String> favoriteTrips = <String>{};

  @override
  Widget build(BuildContext context) {
    final shuttleProvider = Provider.of<ShuttleProvider>(context);
    final authProvider = Provider.of<AuthenProvider>(context);

    // Get the current student's ID
    final String studentId = authProvider.user!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home'),
        actions: [
          IconButton(
              onPressed: (){
                authProvider.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Available Trips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Display available trips
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

                      String destination = tripData.containsKey('destination')
                          ? tripData['destination']
                          : 'Unknown Destination';

                      Timestamp timestamp = tripData['timestamp'];
                      DateTime dateTime = timestamp.toDate();

                      // Check if the trip is a favorite by looking at the favoriteTrips set
                      bool isFavorite = favoriteTrips.contains(trip.id);

                      return ListTile(
                        title: Text('Trip ${index + 1} to $destination'),
                        subtitle: Text('Completed on: ${dateTime.toString()}'),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey, // Change color based on favorite status
                          ),
                          onPressed: () async {
                            // Toggle favorite status
                            if (isFavorite) {
                              await _removeFavoriteTrip(studentId, trip.id);
                            } else {
                              await _saveFavoriteTrip(studentId, trip.id, destination, dateTime);
                            }

                            // Update the UI by toggling favorite state locally
                            setState(() {
                              if (isFavorite) {
                                favoriteTrips.remove(trip.id);
                              } else {
                                favoriteTrips.add(trip.id);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Favorite Trips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Display favorite trips
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('students')
                  .doc(studentId)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final favorites = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final favoriteTrip = favorites[index];
                      Map<String, dynamic> favoriteData = favoriteTrip.data() as Map<String, dynamic>;

                      String destination = favoriteData['destination'];
                      Timestamp timestamp = favoriteData['timestamp'];
                      DateTime dateTime = timestamp.toDate();

                      return ListTile(
                        title: Text('Favorite Trip to $destination'),
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
    );
  }

  // Method to save a favorite trip for the student
  Future<void> _saveFavoriteTrip(String studentId, String tripId, String destination, DateTime timestamp) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .collection('favorites')
        .doc(tripId)
        .set({
      'destination': destination,
      'timestamp': Timestamp.fromDate(timestamp),
    });
  }

  // Method to remove a favorite trip
  Future<void> _removeFavoriteTrip(String studentId, String tripId) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .collection('favorites')
        .doc(tripId)
        .delete();
  }

  // Fetch the favorite trips when the widget is initialized
  @override
  void initState() {
    super.initState();
    _fetchFavoriteTrips();
  }

  // Method to fetch the favorite trips for the student
  Future<void> _fetchFavoriteTrips() async {
    final authProvider = Provider.of<AuthenProvider>(context, listen: false);
    final String studentId = authProvider.user!.uid;

    final favoritesSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .collection('favorites')
        .get();

    setState(() {
      favoriteTrips = Set<String>.from(favoritesSnapshot.docs.map((doc) => doc.id));
    });
  }
}
