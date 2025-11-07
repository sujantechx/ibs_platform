import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ibs_platform/core/routes/course_routes.dart';


import 'dart:developer' as developer;

// 1. Import your single source of truth for route names
import '../../courses/logic/auth/auth_bloc.dart';
import '../../courses/logic/auth/auth_state.dart';
import 'app_route_constants.dart';

// 2. Import all your modular route files



// 3. Import your core pages (Splash, Home, Login, etc.)
import '../../splash/splash_page.dart';
import '../../home/home_page.dart';
import '../../courses/ui/presentation/screens/auth/login_screen.dart';
import '../../courses/ui/presentation/screens/auth/register_screen.dart';
import '../../courses/ui/presentation/screens/auth/approval_pending_screen.dart';
import 'calendar_routes.dart';
import 'japa_routes.dart'; // For RegisterScreen
import 'vaishnav_puran_routes.dart';
import 'vaishnav_song_routes.dart';

class AppRouter {
  final AuthCubit authCubit;
  late final GoRouter router;

  AppRouter({required this.authCubit}) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),

      // 4. Combine all route lists from all features
      routes: [
        // --- Core App Routes ---
        GoRoute(
            path: AppRoutes.splash,
            builder: (context, state) => const SplashPage()),
        GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage()),
        GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => const LoginScreen()),
        GoRoute(path: AppRoutes.register, builder: (context, state) {
          final courseId = state.extra as String? ?? '';
          return RegisterScreen(courseId: courseId);
        }),
        GoRoute(
            path: AppRoutes.pendingApproval,
            builder: (context, state) => const PendingApprovalScreen()),

        // --- Feature Module Routes ---
        // The spread operator '...' adds all routes from each list
        ...CalendarRoutes.routes,
        ...JapaRoutes.routes,
        ...PuranRoutes.routes,
        ...SongRoutes.routes,

        // This one line adds your ENTIRE courses module
        ...AppRoutesCourses.routes,
      ],

      // 5. This is the new, unified Redirect Logic for the whole app
      redirect: (context, state) {
        final authState = authCubit.state;
        final currentLocation = state.matchedLocation;
        developer.log('Redirect check: authState=$authState, currentLocation=$currentLocation');

        // --- Public Routes ---
        // These can be accessed by anyone, anytime.
        final isPublicRoute = [
          AppRoutes.splash,
          AppRoutesCourses.publicCourses,
          AppRoutesCourses.courseDetail,
          AppRoutesCourses.qrPayment,
          AppRoutes.login,
          AppRoutes.register,
        ].contains(currentLocation);

        // --- 1. Handle Initial and Loading States ---
        if (authState is AuthInitial || authState is AuthLoading) {
          return isPublicRoute ? null : AppRoutes.splash;
        }

        // --- 2. Handle Unauthenticated State ---
        if (authState is Unauthenticated) {
          if (authState.pendingApproval) {
            return currentLocation != AppRoutes.pendingApproval
                ? AppRoutes.pendingApproval
                : null;
          }
          // If not pending and not on a public route, send to public courses
          return isPublicRoute ? null : AppRoutesCourses.publicCourses;
        }

        // --- 3. Handle Authenticated State ---
        if (authState is Authenticated) {
          final user = authState.userModel;

          // If user is not approved, lock them to the pending screen
          if (user.status != 'approved') {
            return currentLocation != AppRoutes.pendingApproval
                ? AppRoutes.pendingApproval
                : null;
          }

          // Routes that are for authentication (splash, login, etc.)
          final isAuthRoute = [
            AppRoutes.splash,
            AppRoutes.login,
            AppRoutes.register,
            AppRoutes.pendingApproval,
          ].contains(currentLocation);

          if (user.role == 'admin') {
            // Admin-specific routes
            // final isAdminRoute =
            // currentLocation.startsWith(AppRoutes.adminDashboard);

            // If admin is on an auth route, send to their dashboard
            if (isAuthRoute) {
              return AppRoutes.adminDashboard;
            }

            // Allow admin to see everything else (home, calendar, admin, etc.)
            return null;

          } else { // User is a 'student'
            // Admin-only routes
            final isAdminRoute =
            currentLocation.startsWith(AppRoutes.adminDashboard);

            // If student is on an admin route, send them to the new home
            if (isAdminRoute) {
              return AppRoutes.home;
            }

            // If student is on an auth route, send them to the new home
            if (isAuthRoute) {
              return AppRoutes.home;
            }

            // Allow student to see all other routes
            // (home, calendar, subjectsList, profile, etc.)
            return null;
          }
        }

        // Default: No redirect
        return null;
      },
    );
  }
}

// This helper class makes GoRouter listen to BLoC state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      developer.log('AuthCubit stream event: $event');
      notifyListeners();
    });
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}