import 'package:chatty/provider/shuttle_location_provider.dart';
import 'package:chatty/view/shuttle_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShuttleLocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shuttle Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ShuttleTrackingScreen(shuttleId: 1), // Replace with actual shuttle ID
    );
  }
}
