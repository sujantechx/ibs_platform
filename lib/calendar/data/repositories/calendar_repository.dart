import 'package:ibs_platform/calendar/data/models/event.dart';

class CalendarRepository {
  Future<List<Event>> getEvents() async {
    // In a real app, you would fetch this from a database or API
    return [
      Event(title: 'Event 1', date: DateTime.now()),
      Event(title: 'Event 2', date: DateTime.now().add(const Duration(days: 1))),
    ];
  }
}

