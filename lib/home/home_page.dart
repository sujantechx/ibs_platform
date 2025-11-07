import 'package:flutter/material.dart';
import 'package:ibs_platform/calendar/ui/calendar_dashboard.dart';
import 'package:ibs_platform/japa_counter/ui/japa_counter_dashboard.dart';
import 'package:ibs_platform/vaishnav_puran/ui/vaishnav_puran_dashboard.dart';
import 'package:ibs_platform/vaishnav_song/ui/vaishnav_song_dashboard.dart';

import '../courses/ui/presentation/screens/splash/splash_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    SplashScreen(),
    const CalendarDashboard(),
    const JapaCounterDashboard(),
    const VaishnavPuranDashboard(),
    const VaishnavSongDashboard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Japa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Puran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Songs',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

