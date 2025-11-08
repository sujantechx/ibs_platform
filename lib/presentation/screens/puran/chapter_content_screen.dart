// lib/presentation/screens/puran/chapter_content_screen.dart

import 'package:flutter/material.dart';

class ChapterContentScreen extends StatelessWidget {
  final String puranId;
  final String subjectId;
  final String chapterId;

  const ChapterContentScreen({super.key, required this.puranId, required this.subjectId, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter Content'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text Content:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('No text content available yet.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('PDFs:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('No PDFs available yet.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Videos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('No videos available yet.', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
