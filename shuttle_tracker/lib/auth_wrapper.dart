import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Student home screen
import 'package:shuttle_tracker/student_home_screen.dart';
import 'auth_provider.dart';
import 'driver_home_screen.dart';
import 'login_screen.dart';             // Login screen

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenProvider>(
      builder: (context, auth, child) => StreamBuilder<User?>(
        stream: auth.onAuthStateChange(),  // Stream to listen for authentication state changes
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data;
            // User is logged in, now fetch the user's role from Firestore
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.user!.uid)  // Fetch the logged-in user's document from Firestore
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snap) {
                if (snap.hasData && snap.data != null) {
                  final userDoc = snap.data;
                  final userData = userDoc!.data() as Map<String, dynamic>;
                  if (userData.containsKey('role')) {
                    final String role = userData['role'];
                    if (role == 'Driver') {
                      // If user role is Driver, navigate to DriverHomeScreen
                      return const DriverHome();
                    } else if (role == 'Student') {
                      // If user role is Student, navigate to StudentHomeScreen
                      return const StudentHome();
                    } else {
                      // If role is unknown or incorrect, show an error screen or redirect
                      return const Scaffold(
                        body: Center(child: Text('Unknown user role')),
                      );
                    }
                  } else {
                    // If user document exists but no role is found
                    return const Scaffold(
                      body: Center(child: Text('User role not defined')),
                    );
                  }
                } else if (snap.hasError) {
                  return const Scaffold(
                    body: Center(child: Text('Error loading user data')),
                  );
                } else {
                  // Loading state
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }
          // If user is not logged in, navigate to the LoginScreen
          return LoginScreen();
        },
      ),
    );
  }
}
