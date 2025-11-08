// lib/presentation/screens/song/song_screen.dart

import 'package:flutter/material.dart';

class SongScreen extends StatelessWidget {
  const SongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song'),
      ),
      body: const Center(
        child: Text('Song Screen - Coming Soon'),
      ),
    );
  }
}
