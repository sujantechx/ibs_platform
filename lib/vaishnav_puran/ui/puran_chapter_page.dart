import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_cubit.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_state.dart';

class PuranChapterPage extends StatefulWidget {
  final String puranId;
  final String subjectId;
  final String chapterId;
  final String chapterTitle;

  const PuranChapterPage({super.key, required this.puranId, required this.subjectId, required this.chapterId, required this.chapterTitle});

  @override
  State<PuranChapterPage> createState() => _PuranChapterPageState();
}

class _PuranChapterPageState extends State<PuranChapterPage> {
  late final PuranCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PuranCubit>();
    _cubit.getChapter(widget.puranId, widget.subjectId, widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chapterTitle)),
      body: BlocBuilder<PuranCubit, PuranState>(
        builder: (context, state) {
          if (state is PuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PuranChapterLoaded && state.puranId == widget.puranId && state.subjectId == widget.subjectId) {
            final chapter = state.chapter;
            if (chapter.content == null || chapter.content!.isEmpty) {
              return const Center(child: Text('No content available'));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(chapter.content!),
            );
          } else if (state is PuranError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Loading chapter...'));
        },
      ),
    );
  }
}

