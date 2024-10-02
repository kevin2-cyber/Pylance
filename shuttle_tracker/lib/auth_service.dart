import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // requesting location permission
  static Future<void> requestLocationPermission() async {
    final locationStatus = await Permission.locationWhenInUse.request();
    if (locationStatus.isGranted) {
      log('Location permission granted', time: DateTime.timestamp());
    } else if (locationStatus.isDenied) {
      log('Location permission denied', time: DateTime.timestamp());
      // Handle the case where permission is denied (e.g., show a dialog)
    } else if (locationStatus.isPermanentlyDenied) {
      log('Location permission permanently denied', time: DateTime.timestamp());
      // Open app settings to allow permission (optional)
      await openAppSettings();
    }
  }
}
