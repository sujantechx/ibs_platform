import 'package:go_router/go_router.dart';
import '../../core/routes/app_route_constants.dart';
import '../../vaishnav_puran/ui/vaishnav_puran_dashboard.dart';

class PuranRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.vaishnavPuran,
          builder: (context, state) => const VaishnavPuranDashboard(),
        ),
      ];
}

