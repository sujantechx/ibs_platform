// lib/presentation/screens/admin/admin_puran_subjects_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/subject_model.dart';
import 'admin_puran_chapters_page.dart';

class AdminPuranSubjectsPage extends StatelessWidget {
  final String puranId;

  const AdminPuranSubjectsPage({super.key, required this.puranId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())..loadSubjects(puranId: puranId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Subjects'),
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

            if (state is SubjectsLoaded) {
              if (state.subjects.isEmpty) {
                return const Center(child: Text('No subjects found. Add one!'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
                  final subject = state.subjects[index];
                  return _buildSubjectItem(context, subject);
                },
              );
            }
            return const Center(child: Text('Failed to load subjects.'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () => _showAddOrEditSubjectDialog(context),
              tooltip: 'Add Subject',
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubjectItem(BuildContext context, SubjectModel subject) {
    return Card(
      child: ListTile(
        title: Text(subject.title),
        subtitle: Text(subject.description),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showAddOrEditSubjectDialog(context, subject: subject);
            } else if (value == 'delete') {
              _showDeleteConfirmationDialog(context, subject);
            } else if (value == 'manage_chapters') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPuranChaptersPage(puranId: puranId, subjectId: subject.id)));
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'manage_chapters', child: Text('Manage Chapters')),
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  void _showAddOrEditSubjectDialog(BuildContext context, {SubjectModel? subject}) {
    final cubit = context.read<PuranCubit>();
    final titleController = TextEditingController(text: subject?.title ?? '');
    final descriptionController = TextEditingController(text: subject?.description ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(subject == null ? 'Add Subject' : 'Edit Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                if (title.isNotEmpty && description.isNotEmpty) {
                  if (subject == null) {
                    cubit.addSubject(puranId: puranId, title: title, description: description);
                  } else {
                    cubit.updateSubject(
                      puranId: puranId,
                      subjectId: subject.id,
                      data: {'title': title, 'description': description, 'updatedAt': Timestamp.now()},
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

  void _showDeleteConfirmationDialog(BuildContext context, SubjectModel subject) {
    final cubit = context.read<PuranCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Subject'),
          content: Text('Are you sure you want to delete "${subject.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteSubject(puranId: puranId, subjectId: subject.id);
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
