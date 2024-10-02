import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timily/app/auth/app_settings.dart';
import 'package:timily/app/provider/auth_provider.dart';
import 'package:timily/app/provider/event_provider.dart';

class Timiely extends StatelessWidget {
  const Timiely({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(
          useMaterial3: true
        ).copyWith(
          textTheme: GoogleFonts.inriaSerifTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        home: const AppSettings(),
      ),
    );
  }
}
