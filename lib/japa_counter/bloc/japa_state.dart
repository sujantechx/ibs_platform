import 'package:equatable/equatable.dart';
import 'package:ibs_platform/japa_counter/data/models/japa_count.dart';

abstract class JapaState extends Equatable {
  const JapaState();

  @override
  List<Object> get props => [];
}

class JapaInitial extends JapaState {}

class JapaLoading extends JapaState {}

class JapaLoaded extends JapaState {
  final JapaCount japaCount;

  const JapaLoaded(this.japaCount);

  @override
  List<Object> get props => [japaCount];
}

class JapaError extends JapaState {
  final String message;

  const JapaError(this.message);

  @override
  List<Object> get props => [message];
}

