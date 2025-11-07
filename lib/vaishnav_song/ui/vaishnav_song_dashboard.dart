import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/vaishnav_song/bloc/song_cubit.dart';
import 'package:ibs_platform/vaishnav_song/bloc/song_state.dart';
import 'package:ibs_platform/vaishnav_song/data/repositories/song_repository.dart';

class VaishnavSongDashboard extends StatelessWidget {
  const VaishnavSongDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SongCubit(songRepository: SongRepository())..getSongs(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vaishnav Songs'),
        ),
        body: BlocBuilder<SongCubit, SongState>(
          builder: (context, state) {
            if (state is SongLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SongLoaded) {
              return ListView.builder(
                itemCount: state.songs.length,
                itemBuilder: (context, index) {
                  final song = state.songs[index];
                  return ListTile(
                    title: Text(song.title),
                    subtitle: Text(song.artist),
                  );
                },
              );
            } else if (state is SongError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Vaishnav Song Dashboard'));
          },
        ),
      ),
    );
  }
}
