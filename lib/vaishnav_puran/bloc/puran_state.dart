import 'package:equatable/equatable.dart';
import 'package:ibs_platform/vaishnav_puran/data/models/puran.dart';

abstract class PuranState extends Equatable {
  const PuranState();

  @override
  List<Object> get props => [];
}

class PuranInitial extends PuranState {}

class PuranLoading extends PuranState {}

class PuranLoaded extends PuranState {
  final List<Puran> purans;

  const PuranLoaded(this.purans);

  @override
  List<Object> get props => [purans];
}

class PuranError extends PuranState {
  final String message;

  const PuranError(this.message);

  @override
  List<Object> get props => [message];
}

