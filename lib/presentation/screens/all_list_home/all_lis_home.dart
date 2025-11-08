import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';

class AllListHome extends StatelessWidget {
  const AllListHome({super.key});

  static const List<_MenuItem> _menuItems = [
    _MenuItem(icon: Icons.book, label: 'Courses', route: AppRoutes.publicCourses),
    _MenuItem(icon: Icons.library_books, label: 'Vaishnav Vedabass', route: AppRoutes.puranList),
    _MenuItem(icon: Icons.calendar_today, label: 'Calendar', route: AppRoutes.calendar),
    _MenuItem(icon: Icons.loop, label: 'Japa Counter', route: AppRoutes.japaCounter),
    _MenuItem(icon: Icons.music_note, label: 'Song', route: AppRoutes.song),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text('Home', style: theme.textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              return _buildMenuItem(context, item: item);
            },
          );
        }),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required _MenuItem item}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => GoRouter.of(context).push(item.route),
        splashColor: colorScheme.primary.withOpacity(0.12),
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 44, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;
  const _MenuItem({required this.icon, required this.label, required this.route});
}