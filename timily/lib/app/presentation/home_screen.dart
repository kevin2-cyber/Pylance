import 'package:flutter/material.dart';
import 'package:timily/app/presentation/home/awards.dart';
import 'package:timily/app/presentation/home/profile.dart';
import 'package:timily/app/presentation/home/summary.dart';
import 'package:timily/core/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _widgetOptions = [
    const CalendarScreen(),
    const Awards(),
    const Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Constants.kSelectedItemColor,
        unselectedItemColor: Colors.black87,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.try_sms_star_outlined), label: 'Awards'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'Profile')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
