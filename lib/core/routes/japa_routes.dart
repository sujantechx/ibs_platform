import 'package:go_router/go_router.dart';
import '../../core/routes/app_route_constants.dart';
import '../../japa_counter/ui/japa_counter_dashboard.dart'; // Your page

class JapaRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.japaCounter,
      builder: (context, state) => const JapaCounterDashboard(),
    ),
  ];
}