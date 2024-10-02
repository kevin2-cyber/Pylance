
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  String _selectedPriority = 'Low';

  DateTime get selectedDate => _selectedDate;
  String get selectedPriority => _selectedPriority;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedPriority(String priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  Future<void> saveEvent(String eventName) async {
    await _firestore.collection('events').add({
      'event': eventName,
      'date': _selectedDate,
      'priority': _selectedPriority,
    });
  }

  Stream<List<Event>> getEventsForDay(DateTime date) {
    return _firestore
        .collection('events')
        .where('date', isEqualTo: date)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Event.fromFirestore(doc))
        .toList());
  }
}

class Event {
  final String name;
  final DateTime date;
  final String priority;

  Event({required this.name, required this.date, required this.priority});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      name: data['event'],
      date: (data['date'] as Timestamp).toDate(),
      priority: data['priority'] ?? 'Low',
    );
  }
}