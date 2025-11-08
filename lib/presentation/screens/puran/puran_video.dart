

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PuranVideo extends StatefulWidget {
  final String? videoId;
  final Future<String>? videoIdFuture;

  const PuranVideo({Key? key, this.videoId, this.videoIdFuture}) : super(key: key);

  @override
  State<PuranVideo> createState() => _PuranVideoState();
}

class _PuranVideoState extends State<PuranVideo> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoId != null) {
      _initController(widget.videoId!);
    }
  }

  void _initController(String id) {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(id) ?? id,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoIdFuture != null) {
      return FutureBuilder<String>(
        future: widget.videoIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Failed to load video id'));
          }
          if (_controller == null) _initController(snapshot.data!);
          return YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            onEnded: (meta) => _controller!.pause(),
          );
        },
      );
    }

    if (widget.videoId != null) {
      return YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        onEnded: (meta) => _controller!.pause(),
      );
    }

    return const Center(child: Text('No video id provided'));
  }
}