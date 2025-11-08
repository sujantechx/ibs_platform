// lib/presentation/screens/puran/subject_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/subject_model.dart';

class SubjectListScreen extends StatelessWidget {
  final String puranId;

  const SubjectListScreen({super.key, required this.puranId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())..loadSubjects(puranId: puranId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Subjects'),
        ),
        body: BlocBuilder<PuranCubit, PuranState>(
          builder: (context, state) {
            if (state is PuranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SubjectsLoaded) {
              return ListView.builder(
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
                  final subject = state.subjects[index];
                  return ListTile(
                    title: Text(subject.title),
                    subtitle: Text(subject.description),
                    onTap: () {
                      context.go('/puran/$puranId/subjects/${subject.id}/chapters');
                    },
                  );
                },
              );
            } else if (state is PuranError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No subjects available'));
          },
        ),
      ),
    );
  }
}
