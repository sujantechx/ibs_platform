// lib/presentation/screens/admin/admin_puran_chapters_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/chapter_model.dart';

class AdminPuranChaptersPage extends StatelessWidget {
  final String puranId;
  final String subjectId;

  const AdminPuranChaptersPage({super.key, required this.puranId, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())..loadChapters(puranId: puranId, subjectId: subjectId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Chapters'),
        ),
        body: BlocConsumer<PuranCubit, PuranState>(
          listener: (context, state) {
            if (state is PuranSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            } else if (state is PuranError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            if (state is PuranLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChaptersLoaded) {
              if (state.chapters.isEmpty) {
                return const Center(child: Text('No chapters found. Add one!'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = state.chapters[index];
                  return _buildChapterItem(context, chapter);
                },
              );
            }
            return const Center(child: Text('Failed to load chapters.'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () => _showAddOrEditChapterDialog(context),
              tooltip: 'Add Chapter',
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChapterItem(BuildContext context, ChapterModel chapter) {
    return Card(
      child: ListTile(
        title: Text(chapter.title),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showAddOrEditChapterDialog(context, chapter: chapter);
            } else if (value == 'delete') {
              _showDeleteConfirmationDialog(context, chapter);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  void _showAddOrEditChapterDialog(BuildContext context, {ChapterModel? chapter}) {
    final cubit = context.read<PuranCubit>();
    final titleController = TextEditingController(text: chapter?.title ?? '');
    final textContentController = TextEditingController(text: chapter?.textContent ?? '');
    final pdfsController = TextEditingController(text: chapter?.pdfs?.join(', ') ?? '');
    final videosController = TextEditingController(text: chapter?.videos?.join(', ') ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(chapter == null ? 'Add Chapter' : 'Edit Chapter'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: textContentController,
                  decoration: const InputDecoration(labelText: 'Text Content'),
                  maxLines: 3,
                ),
                TextField(
                  controller: pdfsController,
                  decoration: const InputDecoration(labelText: 'PDF URLs (comma-separated)'),
                ),
                TextField(
                  controller: videosController,
                  decoration: const InputDecoration(labelText: 'Video URLs (comma-separated)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                final textContent = textContentController.text.trim();
                final pdfs = pdfsController.text.trim().isEmpty ? <String>[] : pdfsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                final videos = videosController.text.trim().isEmpty ? <String>[] : videosController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                if (title.isNotEmpty) {
                  if (chapter == null) {
                    cubit.addChapter(
                      puranId: puranId,
                      subjectId: subjectId,
                      title: title,
                      textContent: textContent.isEmpty ? null : textContent,
                      pdfs: pdfs,
                      videos: videos,
                    );
                  } else {
                    cubit.updateChapter(
                      puranId: puranId,
                      subjectId: subjectId,
                      chapterId: chapter.id,
                      data: {
                        'title': title,
                        'textContent': textContent.isEmpty ? null : textContent,
                        'pdfs': pdfs,
                        'videos': videos,
                        'updatedAt': Timestamp.now(),
                      },
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ChapterModel chapter) {
    final cubit = context.read<PuranCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Chapter'),
          content: Text('Are you sure you want to delete "${chapter.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteChapter(puranId: puranId, subjectId: subjectId, chapterId: chapter.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
