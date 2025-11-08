
// lib/presentation/screens/puran/chapter_list_screen.dart

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/chapter_model.dart';
import 'chapter_content_screen.dart';

class ChapterListScreen extends StatelessWidget {
  final String puranId;
  final String subjectId;

  const ChapterListScreen({super.key, required this.puranId, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())
        ..loadChapters(puranId: puranId, subjectId: subjectId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chapters'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: BlocBuilder<PuranCubit, PuranState>(
            builder: (context, state) {
              if (state is PuranLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ChaptersLoaded) {
                final chapters = state.chapters;
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<PuranCubit>().loadChapters(puranId: puranId, subjectId: subjectId);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    itemCount: chapters.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final ChapterModel chapter = chapters[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () {
                            developer.log('Chapter tapped: puranId=$puranId subjectId=$subjectId chapterId=${chapter.id}');
                            assert(puranId.isNotEmpty, 'puranId is empty when navigating to ChapterContentScreen');
                            assert(subjectId.isNotEmpty, 'subjectId is empty when navigating to ChapterContentScreen');
                            assert(chapter.id.isNotEmpty, 'chapter.id is empty when navigating to ChapterContentScreen');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChapterContentScreen(
                                  puranId: puranId,
                                  subjectId: subjectId,
                                  chapterId: chapter.id,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chapter.title,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        chapter.id,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is PuranError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 42, color: Theme.of(context).colorScheme.error),
                        const SizedBox(height: 12),
                        Text('Something went wrong', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.read<PuranCubit>().loadChapters(puranId: puranId, subjectId: subjectId),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_outlined, size: 44, color: Colors.grey.shade500),
                      const SizedBox(height: 12),
                      Text('No chapters available', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}