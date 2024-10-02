import 'package:flutter/material.dart';

class PastDateChecker extends StatelessWidget {
  final DateTime dateToCheck;
  final Widget pastWidget;
  final Widget futureWidget;

  const PastDateChecker({
    super.key,
    required this.dateToCheck,
    required this.pastWidget,
    required this.futureWidget,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return now.isAfter(dateToCheck) ? pastWidget : futureWidget;
  }
}