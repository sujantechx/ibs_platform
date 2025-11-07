import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router
import 'package:ibs_platform/core/routes/app_route_constants.dart'; // Import common constants
import 'package:ibs_platform/core/routes/course_routes.dart'; // Import course-specific route constants

// A simple class to hold the data for each grid item
class _GridItem {
  const _GridItem({
    required this.icon,
    required this.label,
    required this.routePath, // This is the GoRouter path
  });

  final IconData icon;
  final String label;
  final String routePath;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Create a list of your grid items using the route constants
  static final List<_GridItem> _gridItems = <_GridItem>[
    _GridItem(
      icon: Icons.school,
      label: 'Courses',
      // This path goes to the first tab of your Student Dashboard
      // point to the public courses list which is provided in the main router
      routePath: AppRoutesCourses.publicCourses,
    ),
    _GridItem(
      icon: Icons.calendar_today,
      label: 'Calendar',
      routePath: AppRoutes.calendar,
    ),
    _GridItem(
      icon: Icons.add_circle_outline,
      label: 'Japa',
      routePath: AppRoutes.japaCounter,
    ),
    _GridItem(
      icon: Icons.book,
      label: 'Puran',
      routePath: AppRoutes.vaishnavPuran,
    ),
    _GridItem(
      icon: Icons.music_note,
      label: 'Songs',
      routePath: AppRoutes.vaishnavSong,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IBS Platform'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _gridItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (BuildContext context, int index) {
            final item = _gridItems[index];
            return _GridItemTile(item: item);
          },
        ),
      ),
    );
  }
}

class _GridItemTile extends StatelessWidget {
  const _GridItemTile({required this.item});

  final _GridItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // --- USE context.push() FOR NAVIGATION ---
          context.push(item.routePath);
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              item.icon,
              size: 50.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16.0),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}