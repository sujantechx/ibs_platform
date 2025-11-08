// lib/presentation/screens/puran/subject_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/subject_model.dart';

class SubjectListScreen extends StatefulWidget {
  final String puranId;

  const SubjectListScreen({super.key, required this.puranId});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      PuranCubit(puranRepository: PuranRepository())..loadSubjects(puranId: widget.puranId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Subjects'),
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search subjects',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<PuranCubit, PuranState>(
                  builder: (context, state) {
                    if (state is PuranLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SubjectsLoaded) {
                      final List<SubjectModel> subjects = state.subjects
                          .where((s) =>
                      s.title.toLowerCase().contains(_query.toLowerCase()) ||
                          s.description.toLowerCase().contains(_query.toLowerCase()))
                          .toList();

                      if (subjects.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              _query.isEmpty ? 'No subjects available' : 'No results for \"$_query\"',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<PuranCubit>().loadSubjects(puranId: widget.puranId);
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          itemCount: subjects.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final subject = subjects[index];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                leading: CircleAvatar(
                                  backgroundColor:
                                  Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                  child: Text(
                                    subject.title.isNotEmpty ? subject.title[0].toUpperCase() : '?',
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(subject.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  subject.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () {
                                    context.push('/puran/${widget.puranId}/subjects/${subject.id}/chapters');
                                  },
                                ),
                                onTap: () {
                                  context.push('/puran/${widget.puranId}/subjects/${subject.id}/chapters');
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is PuranError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Something went wrong', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(state.message, textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<PuranCubit>().loadSubjects(puranId: widget.puranId),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}