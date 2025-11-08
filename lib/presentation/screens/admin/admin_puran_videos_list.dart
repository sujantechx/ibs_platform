import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/chapter_model.dart';

class AdminPuranVideosList extends StatelessWidget {
  final String puranId;
  final String subjectId;
  final String chapterId;

  const AdminPuranVideosList({super.key, required this.puranId, required this.subjectId, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())..loadChapterContent(puranId: puranId, subjectId: subjectId, chapterId: chapterId),
      child: BlocConsumer<PuranCubit, PuranState>(
        listener: (context, state) {
          if (state is PuranSuccess) {
            ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            // reload content
            context.read<PuranCubit>().loadChapterContent(puranId: puranId, subjectId: subjectId, chapterId: chapterId);
          } else if (state is PuranError) {
            ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is PuranLoading) return const Center(child: CircularProgressIndicator());
          if (state is ChapterContentLoaded) {
            final ChapterModel chapter = state.chapter;
            final videos = chapter.videos ?? [];
            if (videos.isEmpty) {
              return Center(child: Text('No videos. Tap + to add one.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final url = videos[index];
                return Card(
                  child: ListTile(
                    title: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('Video ${index + 1}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          _showAddOrEditDialog(context, initialValue: url, index: index, existing: videos);
                        } else if (value == 'delete') {
                          final updated = List<String>.from(videos)..removeAt(index);
                          await _updateVideos(context, updated);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Failed to load chapter content.'));
        },
      ),
    );
  }

  void _showAddOrEditDialog(BuildContext context, {String? initialValue, int? index, required List<String> existing}) {
    final controller = TextEditingController(text: initialValue ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(initialValue == null ? 'Add Video URL' : 'Edit Video URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Video URL'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () async {
            final val = controller.text.trim();
            if (val.isNotEmpty) {
              final updated = List<String>.from(existing);
              if (index == null) {
                updated.add(val);
              } else {
                updated[index] = val;
              }
              await _updateVideos(context, updated);
              Navigator.of(ctx).pop();
            }
          }, child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _updateVideos(BuildContext context, List<String> videos) async {
    try {
      await context.read<PuranCubit>().updateChapter(
            puranId: puranId,
            subjectId: subjectId,
            chapterId: chapterId,
            data: {'videos': videos, 'updatedAt': Timestamp.now()},
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update videos: $e')));
    }
  }
}

