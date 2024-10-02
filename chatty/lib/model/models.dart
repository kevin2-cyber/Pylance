import 'package:flutter/cupertino.dart';

class ShuttleLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  ShuttleLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory ShuttleLocation.fromJson(Map<String, dynamic> json) {
    return ShuttleLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}


class WayPoint {
  final double latitude;
  final double longitude;
  final int sequence;

  WayPoint({
    required this.latitude,
    required this.longitude,
    required this.sequence,
  });

  factory WayPoint.fromJson(Map<String, dynamic> json) {
    return WayPoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
      sequence: json['sequence'],
    );
  }
}

class ShuttleRoute {
  final String name;
  final List<WayPoint> waypoints;

  ShuttleRoute({required this.name, required this.waypoints});

  factory ShuttleRoute.fromJson(Map<String, dynamic> json) {
    List<WayPoint> waypoints = (json['waypoints'] as List)
        .map((wp) => WayPoint.fromJson(wp))
        .toList();
    return ShuttleRoute(name: json['name'], waypoints: waypoints);
  }
}
