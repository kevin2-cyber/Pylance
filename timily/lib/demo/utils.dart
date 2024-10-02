import 'package:intl/intl.dart';

import 'event.dart';

class AppUtils {
  static Map<DateTime, List<Event>> events = {};

  static List<Event> getEventsForDay(DateTime day) {
    // retrieve all events from selected day
    return events[day] ?? [];
  }
  static String returnDay(DateTime date) {
    return DateFormat.d('en_US').format(date);
  }

  static String returnMonth(DateTime date) {
    return DateFormat.MMMM().format(date);
  }
}