import 'package:ibs_platform/vaishnav_song/data/models/song.dart';

class SongRepository {
  Future<List<Song>> getSongs() async {
    // In a real app, you would fetch this from a database or API
    return [
      Song(title: 'Song 1', artist: 'Artist 1', url: 'url1'),
      Song(title: 'Song 2', artist: 'Artist 2', url: 'url2'),
    ];
  }
}

