// language: dart
import 'package:flutter/material.dart';
import 'package:ibs_platform/presentation/screens/puran/puran_pdf.dart';
import 'package:ibs_platform/presentation/screens/puran/puran_video.dart';
import 'package:ibs_platform/presentation/screens/puran/text_viewer_screen.dart';

import '../../../data/repositories/puran_repository.dart';
import '../../../data/models/chapter_model.dart';

class ChapterContentScreen extends StatefulWidget {
  final String puranId;
  final String subjectId;
  final String chapterId;

  const ChapterContentScreen({
    super.key,
    required this.puranId,
    required this.subjectId,
    required this.chapterId,
  });

  @override
  State<ChapterContentScreen> createState() => _ChapterContentScreenState();
}

class _ChapterContentScreenState extends State<ChapterContentScreen> {
  late Future<ChapterModel> _chapterFuture;

  @override
  void initState() {
    super.initState();
    _chapterFuture = PuranRepository().getChapter(
      puranId: widget.puranId,
      subjectId: widget.subjectId,
      chapterId: widget.chapterId,
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter Content"),
        centerTitle: false,
        elevation: 1,
      ),
      body: FutureBuilder<ChapterModel>(
        future: _chapterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) return const Center(child: Text("No data found"));

          final chapter = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // TEXT CONTENT PREVIEW (modern card)
              _sectionHeader("Text", Icons.article),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: (chapter.textContent != null && chapter.textContent!.trim().isNotEmpty)
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TextViewerScreen(text: chapter.textContent!)),
                    );
                  }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            (chapter.textContent != null && chapter.textContent!.trim().isNotEmpty)
                                ? chapter.textContent!
                                : "No text available",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PDF SECTION COLLAPSIBLE (hide raw url, show friendly label)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: _sectionHeader("PDFs", Icons.picture_as_pdf),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                children: (chapter.pdfs != null && chapter.pdfs!.isNotEmpty)
                    ? List.generate(chapter.pdfs!.length, (index) {
                  final pdfUrl = chapter.pdfs![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                        child: Icon(Icons.picture_as_pdf, color: Theme.of(context).colorScheme.primary),
                      ),
                      title: Text("PDF ${index + 1}", style: Theme.of(context).textTheme.bodyLarge),
                      subtitle: const Text("Tap to open"),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PuranPdf(url: pdfUrl)),
                        );
                      },
                    ),
                  );
                })
                    : [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: Text("No PDFs available", style: Theme.of(context).textTheme.bodySmall)),
                  )
                ],
              ),

              const SizedBox(height: 12),

              // VIDEO SECTION COLLAPSIBLE (hide raw id, show friendly label)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: _sectionHeader("Videos", Icons.ondemand_video),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                children: (chapter.videos != null && chapter.videos!.isNotEmpty)
                    ? List.generate(chapter.videos!.length, (index) {
                  final videoId = chapter.videos![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.12),
                        child: Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.secondary),
                      ),
                      title: Text("Video ${index + 1}", style: Theme.of(context).textTheme.bodyLarge),
                      subtitle: const Text("Tap to play"),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PuranVideo(videoId: videoId)),
                        );
                      },
                    ),
                  );
                })
                    : [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: Text("No videos available", style: Theme.of(context).textTheme.bodySmall)),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}