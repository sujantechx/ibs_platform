// lib/presentation/screens/puran/chapter_content_screen.dart

import 'package:flutter/material.dart';

import '../../../data/repositories/puran_repository.dart';
import '../../../data/models/chapter_model.dart';

class ChapterContentScreen extends StatefulWidget {
  final String puranId;
  final String subjectId;
  final String chapterId;

  const ChapterContentScreen({super.key, required this.puranId, required this.subjectId, required this.chapterId});

  @override
  State<ChapterContentScreen> createState() => _ChapterContentScreenState();
}

class _ChapterContentScreenState extends State<ChapterContentScreen> {
  late Future<ChapterModel> _chapterFuture;

  @override
  void initState() {
    super.initState();
    // Defensive checks: if any id is empty, create a future that throws for clear error display
    if (widget.puranId.isEmpty || widget.subjectId.isEmpty || widget.chapterId.isEmpty) {
      _chapterFuture = Future<ChapterModel>.error('Invalid IDs provided for chapter content');
    } else {
      _chapterFuture = PuranRepository().getChapter(
        puranId: widget.puranId,
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter Content'),
      ),
      body: FutureBuilder<ChapterModel>(
        future: _chapterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading chapter: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Chapter not found.'));
          }

          final chapter = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Text Content:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (chapter.textContent != null && chapter.textContent!.trim().isNotEmpty)
                  Text(chapter.textContent!, style: const TextStyle(fontSize: 16))
                else
                  const Text('No text content available yet.', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),

                const Text('PDFs:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (chapter.pdfs != null && chapter.pdfs!.isNotEmpty)
                  ...chapter.pdfs!.map((pdf) => ListTile(
                        leading: const Icon(Icons.picture_as_pdf),
                        title: Text(pdf),
                        onTap: () {
                          // You can integrate url_launcher to open this URL.
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open PDF: $pdf')));
                        },
                      ))
                else
                  const Text('No PDFs available yet.', style: TextStyle(fontSize: 16)),

                const SizedBox(height: 20),
                const Text('Videos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (chapter.videos != null && chapter.videos!.isNotEmpty)
                  ...chapter.videos!.map((video) => ListTile(
                        leading: const Icon(Icons.ondemand_video),
                        title: Text(video),
                        onTap: () {
                          // You can integrate url_launcher to open this URL.
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open Video: $video')));
                        },
                      ))
                else
                  const Text('No videos available yet.', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
