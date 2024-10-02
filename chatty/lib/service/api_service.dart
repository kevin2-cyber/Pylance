import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/models.dart';

class ApiService {
  final String baseUrl = 'http://10.11.24.49:4500/api'; // Replace with your actual API URL

  Future<void> updateShuttleLocation(int shuttleId, ShuttleLocation location) async {
    final url = Uri.parse('$baseUrl/locations/$shuttleId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(location.toJson()),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        log('Location updated successfully');
        print('Location updated successfully');
      }
    } else {
      if (kDebugMode) {
        log('Failed to update location');
        print('Failed to update location');
      }
      throw Exception('Failed to update location');
    }
  }

  Future<List<ShuttleRoute>> getShuttleRoutes(int shuttleId) async {
    final url = Uri.parse('$baseUrl/shuttles/$shuttleId/routes');
    final response = await http.get(url);

    if(response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => ShuttleRoute.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch routes');
    }
  }

  Future<List<ShuttleLocation>> getShuttleHistory(int shuttleId) async {
    final url = Uri.parse('$baseUrl/locations/$shuttleId/history');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => ShuttleLocation.fromJson(json)).toList();
    } else {
      if (kDebugMode) {
        print('Failed to fetch history');
      }
      throw Exception('Failed to fetch history');
    }
  }
}
