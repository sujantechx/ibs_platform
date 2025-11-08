// lib/presentation/screens/puran/chapter_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/chapter_model.dart';

class ChapterListScreen extends StatelessWidget {
  final String puranId;
  final String subjectId;

  const ChapterListScreen({super.key, required this.puranId, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())..loadChapters(puranId: puranId, subjectId: subjectId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chapters'),
        ),
        body: BlocBuilder<PuranCubit, PuranState>(
          builder: (context, state) {
            if (state is PuranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChaptersLoaded) {
              return ListView.builder(
                itemCount: state.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = state.chapters[index];
                  return ListTile(
                    title: Text(chapter.title),
                    onTap: () {
                      // Navigate to content screen, assuming content is in chapters
                      // For now, just show a placeholder
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Content for ${chapter.title}')),
                      );
                    },
                  );
                },
              );
            } else if (state is PuranError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No chapters available'));
          },
        ),
      ),
    );
  }
}
