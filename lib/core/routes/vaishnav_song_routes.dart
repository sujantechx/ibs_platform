import 'package:go_router/go_router.dart';
import '../../core/routes/app_route_constants.dart';
import '../../vaishnav_song/ui/vaishnav_song_dashboard.dart';

class SongRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.vaishnavSong,
          builder: (context, state) => const VaishnavSongDashboard(),
        ),
      ];
}

