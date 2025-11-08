// lib/presentation/screens/admin/manage_puran_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/puran_model.dart';
import 'admin_puran_subjects_page.dart';

class ManagePuranScreen extends StatelessWidget {
  const ManagePuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())..loadPurans(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Vaishnav Puran'),
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

            if (state is PuransLoaded) {
              if (state.purans.isEmpty) {
                return const Center(child: Text('No purans found. Add one!'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.purans.length,
                itemBuilder: (context, index) {
                  final puran = state.purans[index];
                  return _buildPuranItem(context, puran);
                },
              );
            }
            return const Center(child: Text('Failed to load purans.'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () => _showAddOrEditPuranDialog(context),
              tooltip: 'Add Puran',
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPuranItem(BuildContext context, PuranModel puran) {
    return Card(
      child: ListTile(
        title: Text(puran.title),
        subtitle: Text(puran.description),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showAddOrEditPuranDialog(context, puran: puran);
            } else if (value == 'delete') {
              _showDeleteConfirmationDialog(context, puran);
            } else if (value == 'manage_subjects') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPuranSubjectsPage(puranId: puran.id)));
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'manage_subjects', child: Text('Manage Subjects')),
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  void _showAddOrEditPuranDialog(BuildContext context, {PuranModel? puran}) {
    final cubit = context.read<PuranCubit>();
    final titleController = TextEditingController(text: puran?.title ?? '');
    final descriptionController = TextEditingController(text: puran?.description ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(puran == null ? 'Add Puran' : 'Edit Puran'),
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
                  if (puran == null) {
                    cubit.addPuran(title: title, description: description);
                  } else {
                    cubit.updatePuran(
                      puranId: puran.id,
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

  void _showDeleteConfirmationDialog(BuildContext context, PuranModel puran) {
    final cubit = context.read<PuranCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Puran'),
          content: Text('Are you sure you want to delete "${puran.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deletePuran(puranId: puran.id);
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
