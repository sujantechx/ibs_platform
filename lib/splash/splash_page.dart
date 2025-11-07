import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ibs_platform/core/routes/app_route_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    developer.log('SplashPage.initState called');
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    if (!mounted) return;
    developer.log('SplashPage navigating to Home');
    // Use GoRouter to navigate when using MaterialApp.router
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    developer.log('SplashPage.build');
    return const Scaffold(
      body: Center(
        child: Text('Splash Page'),
      ),
    );
  }
}
