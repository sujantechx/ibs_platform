import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_cubit.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_state.dart';
import 'package:ibs_platform/vaishnav_puran/data/repositories/puran_repository.dart';
import 'package:ibs_platform/vaishnav_puran/ui/puran_subjects_page.dart' as subjects_page;

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
              return const widgets.Center(child: CircularProgressIndicator());
            } else if (state is PuranLoaded) {
              return ListView.builder(
                itemCount: state.purans.length,
                itemBuilder: (context, index) {
                  final puran = state.purans[index];
                  return ListTile(
                    title: Text(puran.title),
                    subtitle: puran.description != null
                        ? Text(puran.description!)
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      final cubit = context.read<PuranCubit>();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: subjects_page.PuranSubjectsPage(puranId: puran.id, puranTitle: puran.title),
                        ),
                      ));
                    },
                  );
                },
              );
            } else if (state is PuranError) {
              return widgets.Center(child: Text(state.message));
            }
            return const widgets.Center(child: Text('Vaishnav Puran Dashboard'));
          },
        ),
      ),
    );
  }
}
