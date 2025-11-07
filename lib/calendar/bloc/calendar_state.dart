import 'package:equatable/equatable.dart';
import 'package:ibs_platform/calendar/data/models/event.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<Event> events;

  const CalendarLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object> get props => [message];
}

