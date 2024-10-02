import 'dart:math';

import 'package:flutter/material.dart';

import '../model/models.dart';
import '../service/api_service.dart';

class ShuttleLocationProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<ShuttleRoute> routes = [];
  ShuttleLocation? currentLocation;
  bool isLoading = false;
  bool isOnRoute = true;
  String? errorMessage;

  Future<void> fetchShuttleRoutes(int shuttleId) async {
    isLoading = true;
    notifyListeners();

    try {
      routes = await apiService.getShuttleRoutes(shuttleId);
      errorMessage = null;
    } catch (e) {
      errorMessage = "Failed to load routes: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateShuttleLocation(int shuttleId, ShuttleLocation location) async {
    currentLocation = location;
    notifyListeners();

    try {
      await apiService.updateShuttleLocation(shuttleId, location);
      checkIfOnRoute(location);
    } catch (e) {
      errorMessage = "Failed to update location: $e";
    }
  }

  void checkIfOnRoute(ShuttleLocation location) {
    isOnRoute = false;
    const tolerance = 100; // meters
    for (ShuttleRoute route in routes) {
      for (WayPoint wp in route.waypoints) {
        double distance = _calculateDistance(location.latitude, location.longitude, wp.latitude, wp.longitude);
        if (distance <= tolerance) {
          isOnRoute = true;
          break;
        }
      }
    }
    notifyListeners();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // in km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c * 1000; // convert to meters
  }

  double _toRadians(double degrees) => degrees * (pi / 180);

  Future<void> fetchShuttleLocation(int shuttleId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // Notify listeners that loading has started

    try {
      List<ShuttleLocation> history = await apiService.getShuttleHistory(shuttleId);
      if (history.isNotEmpty) {
        currentLocation = history.last; // Update with the latest location
      } else {
        errorMessage = "No location data available.";
      }
    } catch (e) {
      errorMessage = "Error fetching shuttle location: $e";
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished
    }
  }
}
