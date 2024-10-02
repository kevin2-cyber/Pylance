import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? channel;

  void connect(String shuttleId) {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://10.11.24.49:4500/ws'), // Replace with your WebSocket URL
    );

    channel!.stream.listen((message) {
      if (kDebugMode) {
        log('New location update: $message');
        print('New location update: $message');
      }
      // Handle the received location update
    });
  }

  void close() {
    channel?.sink.close();
  }
}
