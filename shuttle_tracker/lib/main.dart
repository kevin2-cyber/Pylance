import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shuttle_tracker/auth_service.dart';
import 'auth_provider.dart';
import 'auth_wrapper.dart';
import 'firebase_options.dart';
import 'shuttle_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AuthService.requestLocationPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenProvider()),
        ChangeNotifierProvider(create: (_) => ShuttleProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shuttle Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AppSettings(),
      ),
    );
  }
}
