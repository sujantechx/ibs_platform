import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/chapter_model.dart';

class AdminPuranTextsList extends StatelessWidget {
  final String puranId;
  final String subjectId;
  final String chapterId;

  const AdminPuranTextsList({super.key, required this.puranId, required this.subjectId, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())..loadChapterContent(puranId: puranId, subjectId: subjectId, chapterId: chapterId),
      child: BlocConsumer<PuranCubit, PuranState>(
        listener: (context, state) {
          if (state is PuranSuccess) {
            ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            context.read<PuranCubit>().loadChapterContent(puranId: puranId, subjectId: subjectId, chapterId: chapterId);
          } else if (state is PuranError) {
            ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is PuranLoading) return const Center(child: CircularProgressIndicator());
          if (state is ChapterContentLoaded) {
            final ChapterModel chapter = state.chapter;
            List<Map<String, String>> texts = chapter.texts ?? [];
            // Backwards-compat: if no texts list but textContent exists, show it as a single item
            if (texts.isEmpty && (chapter.textContent ?? '').isNotEmpty) {
              texts = [ {'title': 'Text', 'content': chapter.textContent ?? ''} ];
            }

            if (texts.isEmpty) {
              return Center(child: Text('No text entries. Tap + to add one.'));
            }

            return Scaffold(
              body: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: texts.length,
                itemBuilder: (context, index) {
                  final item = texts[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['title'] ?? 'Untitled'),
                      subtitle: Text((item['content'] ?? '').length > 100 ? (item['content'] ?? '').substring(0, 100) + '...' : (item['content'] ?? '')),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            _showAddOrEditDialog(context, existing: texts, index: index);
                          } else if (value == 'delete') {
                            final updated = List<Map<String, String>>.from(texts)..removeAt(index);
                            await _updateTexts(context, updated);
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
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showAddOrEditDialog(context, existing: texts),
                child: const Icon(Icons.add),
              ),
            );
          }
          return const Center(child: Text('Failed to load chapter content.'));
        },
      ),
    );
  }

  void _showAddOrEditDialog(BuildContext context, {required List<Map<String, String>> existing, int? index}) {
    final titleController = TextEditingController(text: index != null ? existing[index]['title'] ?? '' : '');
    final contentController = TextEditingController(text: index != null ? existing[index]['content'] ?? '' : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.92,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          index == null ? 'Add Text Entry' : 'Edit Text Entry',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: contentController,
                          decoration: const InputDecoration(labelText: 'Content'),
                          maxLines: null,
                          minLines: 10,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ),
                ),
                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final title = titleController.text.trim();
                            final content = contentController.text.trim();
                            if (content.isNotEmpty) {
                              final updated = List<Map<String, String>>.from(existing);
                              final entry = {'title': title.isEmpty ? 'Text' : title, 'content': content};
                              if (index == null) {
                                updated.add(entry);
                              } else {
                                updated[index] = entry;
                              }
                              await _updateTexts(context, updated);
                              Navigator.of(ctx).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Content cannot be empty')));
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Save'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _updateTexts(BuildContext context, List<Map<String, String>> texts) async {
    try {
      // Also update textContent to keep backwards compatibility with older clients
      final fallback = texts.isNotEmpty ? texts.first['content'] : null;
      await context.read<PuranCubit>().updateChapter(
            puranId: puranId,
            subjectId: subjectId,
            chapterId: chapterId,
            data: {'texts': texts, 'textContent': fallback, 'updatedAt': Timestamp.now()},
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update texts: $e')));
    }
  }
}

