import 'package:flutter/material.dart';
import 'package:ibs_platform/calendar/ui/calendar_dashboard.dart';
import 'package:ibs_platform/japa_counter/ui/japa_counter_dashboard.dart';
import 'package:ibs_platform/vaishnav_puran/ui/vaishnav_puran_dashboard.dart';
import 'package:ibs_platform/vaishnav_song/ui/vaishnav_song_dashboard.dart';
import 'package:ibs_platform/home/home_page.dart';
import 'package:ibs_platform/splash/splash_page.dart';
import '../../courses/ui/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String calendar = '/calendar';
  static const String courses = '/courses';
  static const String japaCounter = '/japa-counter';
  static const String vaishnavPuran = '/vaishnav-puran';
  static const String vaishnavSong = '/vaishnav-song';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarDashboard());
      case courses:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case japaCounter:
        return MaterialPageRoute(builder: (_) => const JapaCounterDashboard());
      case vaishnavPuran:
        return MaterialPageRoute(builder: (_) => const VaishnavPuranDashboard());
      case vaishnavSong:
        return MaterialPageRoute(builder: (_) => const VaishnavSongDashboard());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

