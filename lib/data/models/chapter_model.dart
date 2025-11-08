// lib/data/models/chapter_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

// Represents a single chapter document.
class ChapterModel {
  final String id;
  final String title;
  final int? chapterNumber;
  final String? textContent;
  final List<String>? pdfs;
  final List<String>? videos;

  ChapterModel({
    required this.id,
    required this.title,
    this.chapterNumber,
    this.textContent,
    this.pdfs,
    this.videos,
  });

  factory ChapterModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChapterModel(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      chapterNumber: data['chapterNumber'] as int?,
      textContent: data['textContent'] as String?,
      pdfs: (data['pdfs'] as List<dynamic>?)?.cast<String>(),
      videos: (data['videos'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
