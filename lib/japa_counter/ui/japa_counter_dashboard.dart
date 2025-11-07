import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/japa_counter/bloc/japa_cubit.dart';
import 'package:ibs_platform/japa_counter/bloc/japa_state.dart';
import 'package:ibs_platform/japa_counter/data/repositories/japa_repository.dart';

class JapaCounterDashboard extends StatelessWidget {
  const JapaCounterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          JapaCubit(japaRepository: JapaRepository())..getJapaCount(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Japa Counter'),
        ),
        body: BlocBuilder<JapaCubit, JapaState>(
          builder: (context, state) {
            if (state is JapaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JapaLoaded) {
              return Center(
                child: Text(
                  'Japa Count: ${state.japaCount.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            } else if (state is JapaError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Japa Counter Dashboard'));
          },
        ),
      ),
    );
  }
}
