import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';

class AllListHome extends StatelessWidget {
  const AllListHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildMenuItem(
              context,
              icon: Icons.book,
              label: 'Courses',
              onTap: () => context.push(AppRoutes.publicCourses),
            ),
            _buildMenuItem(
              context,
              icon: Icons.calendar_today,
              label: 'Calendar',
              onTap: () => context.push(AppRoutes.calendar),
            ),
            _buildMenuItem(
              context,
              icon: Icons.loop,
              label: 'Japa Counter',
              onTap: () => context.push(AppRoutes.japaCounter),
            ),
            _buildMenuItem(
              context,
              icon: Icons.music_note,
              label: 'Song',
              onTap: () => context.push(AppRoutes.song),
            ),
            _buildMenuItem(
              context,
              icon: Icons.library_books,
              label: 'Vaishnav Puran',
              onTap: () => context.push(AppRoutes.puranList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

