import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_cubit.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_state.dart';
import 'package:ibs_platform/vaishnav_puran/ui/puran_chapter_page.dart';

class PuranChaptersPage extends StatefulWidget {
  final String puranId;
  final String subjectId;
  final String subjectTitle;

  const PuranChaptersPage({super.key, required this.puranId, required this.subjectId, required this.subjectTitle});

  @override
  State<PuranChaptersPage> createState() => _PuranChaptersPageState();
}

class _PuranChaptersPageState extends State<PuranChaptersPage> {
  late final PuranCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PuranCubit>();
    _cubit.getChapters(widget.puranId, widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subjectTitle)),
      body: BlocBuilder<PuranCubit, PuranState>(
        builder: (context, state) {
          if (state is PuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PuranChaptersLoaded && state.puranId == widget.puranId && state.subjectId == widget.subjectId) {
            if (state.chapters.isEmpty) {
              return const Center(child: Text('No chapters found'));
            }
            return ListView.builder(
              itemCount: state.chapters.length,
              itemBuilder: (context, index) {
                final chapter = state.chapters[index];
                return ListTile(
                  title: Text(chapter.title),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    final cubit = context.read<PuranCubit>();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: PuranChapterPage(
                          puranId: widget.puranId,
                          subjectId: widget.subjectId,
                          chapterId: chapter.id,
                          chapterTitle: chapter.title,
                        ),
                      ),
                    ));
                  },
                );
              },
            );
          } else if (state is PuranError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Loading chapters...'));
        },
      ),
    );
  }
}

