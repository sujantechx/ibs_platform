import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/calendar/bloc/calendar_cubit.dart';
import 'package:ibs_platform/calendar/bloc/calendar_state.dart';
import 'package:ibs_platform/calendar/data/repositories/calendar_repository.dart';

class CalendarDashboard extends StatelessWidget {
  const CalendarDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CalendarCubit(calendarRepository: CalendarRepository())..getEvents(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
        ),
        body: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if (state is CalendarLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CalendarLoaded) {
              return ListView.builder(
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.date.toString()),
                  );
                },
              );
            } else if (state is CalendarError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Calendar Dashboard'));
          },
        ),
      ),
    );
  }
}
