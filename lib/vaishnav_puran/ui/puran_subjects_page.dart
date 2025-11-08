import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_cubit.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_state.dart';
import 'package:ibs_platform/vaishnav_puran/data/models/puran_subject.dart';
import 'puran_chapters_page.dart';

class PuranSubjectsPage extends StatefulWidget {
  final String puranId;
  final String puranTitle;

  const PuranSubjectsPage({super.key, required this.puranId, required this.puranTitle});

  @override
  State<PuranSubjectsPage> createState() => _PuranSubjectsPageState();
}

class _PuranSubjectsPageState extends State<PuranSubjectsPage> {
  late final PuranCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PuranCubit>();
    _cubit.getSubjects(widget.puranId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.puranTitle)),
      body: BlocBuilder<PuranCubit, PuranState>(
        builder: (context, state) {
          if (state is PuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PuranSubjectsLoaded && state.puranId == widget.puranId) {
            if (state.subjects.isEmpty) {
              return const Center(child: Text('No subjects found'));
            }
            return ListView.builder(
              itemCount: state.subjects.length,
              itemBuilder: (context, index) {
                final PuranSubject subject = state.subjects[index];
                return ListTile(
                  title: Text(subject.title),
                  subtitle: subject.description != null ? Text(subject.description!) : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    final cubit = context.read<PuranCubit>();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: PuranChaptersPage(
                          puranId: widget.puranId,
                          subjectId: subject.id,
                          subjectTitle: subject.title,
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
          return const Center(child: Text('Loading subjects...'));
        },
      ),
    );
  }
}
