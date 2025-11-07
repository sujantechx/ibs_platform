import 'package:go_router/go_router.dart';
import '../../core/routes/app_route_constants.dart';
import '../../calendar/ui/calendar_dashboard.dart'; // Your page

class CalendarRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.calendar,
      builder: (context, state) => const CalendarDashboard(),
    ),
  ];
}