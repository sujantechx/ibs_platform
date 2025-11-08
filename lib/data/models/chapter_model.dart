// lib/data/models/chapter_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

// Represents a single chapter document.
class ChapterModel {
  final String id;
  final String title;
  final int? chapterNumber;
  // Backwards-compatible single text field
  final String? textContent;
  // New: list of text entries with title and content (to better manage multiple text items)
  final List<Map<String, String>>? texts;
  final List<String>? pdfs;
  final List<String>? videos;

  ChapterModel({
    required this.id,
    required this.title,
    this.chapterNumber,
    this.textContent,
    this.texts,
    this.pdfs,
    this.videos,
  });

  factory ChapterModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse texts: stored as a list of maps { 'title': '', 'content': '' }
    List<Map<String, String>>? parsedTexts;
    if (data['texts'] is List<dynamic>) {
      parsedTexts = (data['texts'] as List<dynamic>)
          .where((e) => e is Map)
          .map((e) => Map<String, String>.from((e as Map).map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))))
          .toList();
    }

    return ChapterModel(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      chapterNumber: data['chapterNumber'] as int?,
      textContent: data['textContent'] as String?,
      texts: parsedTexts,
      pdfs: (data['pdfs'] as List<dynamic>?)?.cast<String>(),
      videos: (data['videos'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
