import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ibs_platform/presentation/screens/all_list_home/all_lis_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      // If using go_router:
      GoRouter.of(context).go('/all_list_home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.school, size: 100, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text(
              'IBS Platform',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}