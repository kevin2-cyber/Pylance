import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timily/app/provider/auth_provider.dart';
import 'package:timily/app/presentation/home_screen.dart';
import 'package:timily/app/presentation/login_screen.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, auth, child) {
        return StreamBuilder(
            stream: auth.onAuthStateChanges(),
            builder: (context, snapshot){
              if(snapshot.hasData) {
                return const HomeScreen();
              }
              return const LoginScreen();
            }
        );
      },
    );
  }
}
