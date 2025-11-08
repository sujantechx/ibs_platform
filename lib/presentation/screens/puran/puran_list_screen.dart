// lib/presentation/screens/puran/puran_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/puran_model.dart';

class PuranListScreen extends StatelessWidget {
  const PuranListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      PuranCubit(puranRepository: PuranRepository())..loadPurans(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vaishnav Puran'),
        ),
        body: BlocBuilder<PuranCubit, PuranState>(
          builder: (context, state) {
            if (state is PuranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PuransLoaded) {
              // Call the new helper method to build the grid
              return _buildPuranGrid(context, state.purans);
            } else if (state is PuranError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No purans available'));
          },
        ),
      ),
    );
  }

  /// Helper method to build the GridView
  Widget _buildPuranGrid(BuildContext context, List<PuranModel> purans) {
    return GridView.builder(
      // Add padding around the entire grid
      padding: const EdgeInsets.all(16.0),
      itemCount: purans.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 16.0, // Spacing between columns
        mainAxisSpacing: 16.0, // Spacing between rows
        childAspectRatio: 0.8, // Adjust aspect ratio (width / height)
      ),
      itemBuilder: (context, index) {
        final puran = purans[index];
        // Use the new custom card widget
        return _PuranCard(puran: puran);
      },
    );
  }
}

/// A custom widget for displaying a Puran in a Card
class _PuranCard extends StatelessWidget {
  const _PuranCard({required this.puran});

  final PuranModel puran;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      // Use AntiAlias clipping to respect the rounded corners
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          final location = '/puran/${puran.id}/subjects';
          context.push(location);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image Placeholder ---
            // Replace this with Image.network(puran.imageUrl) if you have one
            AspectRatio(
              aspectRatio: 16 / 10, // Common aspect ratio for images
              child: Container(
                color: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.auto_stories, // A fitting icon
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),

            // --- Text Content ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    puran.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    puran.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}