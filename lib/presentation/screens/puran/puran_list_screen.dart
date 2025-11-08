// lib/presentation/screens/puran/puran_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/puran_repository.dart';
import '../../../logic/puran/puran_cubit.dart';
import '../../../logic/puran/puran_state.dart';
import '../../../data/models/puran_model.dart';

class PuranListScreen extends StatelessWidget {
  const PuranListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuranCubit(puranRepository: PuranRepository())..loadPurans(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vaishnav Puran'),
        ),
        body: BlocBuilder<PuranCubit, PuranState>(
          builder: (context, state) {
            if (state is PuranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PuransLoaded) {
              return ListView.builder(
                itemCount: state.purans.length,
                itemBuilder: (context, index) {
                  final puran = state.purans[index];
                  return ListTile(
                    title: Text(puran.title),
                    subtitle: Text(puran.description),
                    onTap: () {
                      context.go('/puran/${puran.id}/subjects');
                    },
                  );
                },
              );
            } else if (state is PuranError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No purans available'));
          },
        ),
      ),
    );
  }
}
