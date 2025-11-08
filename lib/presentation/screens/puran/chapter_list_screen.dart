// lib/presentation/screens/puran/chapter_list_screen.dart

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/chapter_model.dart';
import 'chapter_content_screen.dart'; // Import the content screen

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
                    subtitle: Text(chapter.id),
                    onTap: () {
                      // Defensive logging before navigation
                      developer.log('Chapter tapped: puranId=$puranId subjectId=$subjectId chapterId=${chapter.id}');
                      assert(puranId.isNotEmpty, 'puranId is empty when navigating to ChapterContentScreen');
                      assert(subjectId.isNotEmpty, 'subjectId is empty when navigating to ChapterContentScreen');
                      assert(chapter.id.isNotEmpty, 'chapter.id is empty when navigating to ChapterContentScreen');

                      // Navigate to content screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChapterContentScreen(puranId: puranId, subjectId: subjectId, chapterId: chapter.id)));
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
