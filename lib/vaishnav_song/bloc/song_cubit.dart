import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/vaishnav_song/bloc/song_state.dart';
import 'package:ibs_platform/vaishnav_song/data/repositories/song_repository.dart';

class SongCubit extends Cubit<SongState> {
  final SongRepository songRepository;

  SongCubit({required this.songRepository}) : super(SongInitial());

  void getSongs() async {
    try {
      emit(SongLoading());
      final songs = await songRepository.getSongs();
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }
}

