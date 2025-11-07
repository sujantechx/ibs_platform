import 'package:equatable/equatable.dart';
import 'package:ibs_platform/vaishnav_song/data/models/song.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class SongLoading extends SongState {}

class SongLoaded extends SongState {
  final List<Song> songs;

  const SongLoaded(this.songs);

  @override
  List<Object> get props => [songs];
}

class SongError extends SongState {
  final String message;

  const SongError(this.message);

  @override
  List<Object> get props => [message];
}

