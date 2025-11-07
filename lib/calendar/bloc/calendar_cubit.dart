import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/calendar/bloc/calendar_state.dart';
import 'package:ibs_platform/calendar/data/repositories/calendar_repository.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepository calendarRepository;

  CalendarCubit({required this.calendarRepository}) : super(CalendarInitial());

  void getEvents() async {
    try {
      emit(CalendarLoading());
      final events = await calendarRepository.getEvents();
      emit(CalendarLoaded(events));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }
}

