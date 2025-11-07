import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_cubit.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_state.dart';
import 'package:ibs_platform/vaishnav_puran/data/repositories/puran_repository.dart';

class VaishnavPuranDashboard extends StatelessWidget {
  const VaishnavPuranDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PuranCubit(puranRepository: PuranRepository())..getPurans(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vaishnav Puran'),
        ),
        body: BlocBuilder<PuranCubit, PuranState>(
          builder: (context, state) {
            if (state is PuranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PuranLoaded) {
              return ListView.builder(
                itemCount: state.purans.length,
                itemBuilder: (context, index) {
                  final puran = state.purans[index];
                  return ListTile(
                    title: Text(puran.title),
                    subtitle: Text(puran.content),
                  );
                },
              );
            } else if (state is PuranError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Vaishnav Puran Dashboard'));
          },
        ),
      ),
    );
  }
}
