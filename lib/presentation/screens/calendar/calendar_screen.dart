// lib/presentation/screens/calendar/calendar_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();

  // events keyed by yyyy-MM-dd -> list of { 'title': ..., 'notes': ... }
  Map<String, List<Map<String, String>>> _events = {};
  static const _kEventsKey = 'calendar_events_json';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  String _dateKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kEventsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _events = decoded.map((k, v) => MapEntry(k, (v as List<dynamic>).map((e) => Map<String, String>.from(e)).toList()));
      } catch (e) {
        _events = {};
      }
    }
    setState(() {});
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_events);
    await prefs.setString(_kEventsKey, encoded);
  }

  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  int _daysInMonth(DateTime month) {
    final beginningNextMonth = (month.month == 12) ? DateTime(month.year + 1, 1, 1) : DateTime(month.year, month.month + 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1)).day;
  }

  Widget _buildCalendar() {
    final firstOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final weekdayOfFirst = firstOfMonth.weekday % 7; // make Sunday = 0
    final daysInMonth = _daysInMonth(_displayedMonth);
    final totalSlots = weekdayOfFirst + daysInMonth;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: _prevMonth, icon: const Icon(Icons.chevron_left)),
            Text('${_displayedMonth.year} - ${_displayedMonth.month.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(onPressed: _nextMonth, icon: const Icon(Icons.chevron_right)),
          ],
        ),
        const SizedBox(height: 6),
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Expanded(child: Center(child: Text('Sun'))),
            Expanded(child: Center(child: Text('Mon'))),
            Expanded(child: Center(child: Text('Tue'))),
            Expanded(child: Center(child: Text('Wed'))),
            Expanded(child: Center(child: Text('Thu'))),
            Expanded(child: Center(child: Text('Fri'))),
            Expanded(child: Center(child: Text('Sat'))),
          ],
        ),
        const SizedBox(height: 6),
        // Days grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ((totalSlots / 7).ceil()) * 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemBuilder: (context, index) {
            final dayIndex = index - weekdayOfFirst + 1;
            if (index < weekdayOfFirst || dayIndex > daysInMonth) {
              return const SizedBox.shrink();
            }
            final date = DateTime(_displayedMonth.year, _displayedMonth.month, dayIndex);
            final key = _dateKey(date);
            final hasEvents = (_events[key]?.isNotEmpty ?? false);
            final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : null,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(dayIndex.toString()),
                    if (hasEvents) const Icon(Icons.event, size: 14, color: Colors.blueAccent),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Map<String, String>> _eventsForSelectedDate() {
    final key = _dateKey(_selectedDate);
    return List<Map<String, String>>.from(_events[key] ?? []);
  }

  Future<void> _addEvent() async {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: notesController, decoration: const InputDecoration(labelText: 'Notes (optional)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final notes = notesController.text.trim();
              if (title.isEmpty) return;
              final key = _dateKey(_selectedDate);
              final list = _events[key] ?? <Map<String, String>>[];
              list.add({'title': title, 'notes': notes});
              _events[key] = list;
              await _saveEvents();
              setState(() {});
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEvent(int index) async {
    final key = _dateKey(_selectedDate);
    final list = _events[key] ?? [];
    if (index < 0 || index >= list.length) return;
    list.removeAt(index);
    if (list.isEmpty) {
      _events.remove(key);
    } else {
      _events[key] = list;
    }
    await _saveEvents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final events = _eventsForSelectedDate();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addEvent),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Events for ${_dateKey(_selectedDate)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${events.length}'),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: events.isEmpty
                  ? const Center(child: Text('No events for this date'))
                  : ListView.separated(
                      itemCount: events.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, idx) {
                        final ev = events[idx];
                        return ListTile(
                          title: Text(ev['title'] ?? ''),
                          subtitle: (ev['notes'] ?? '').isNotEmpty ? Text(ev['notes'] ?? '') : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete event?'),
                                  content: const Text('Are you sure you want to delete this event?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                await _deleteEvent(idx);
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
