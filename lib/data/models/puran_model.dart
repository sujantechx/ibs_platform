// lib/data/models/puran_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PuranModel {
  final String id;
  final String title;
  final String description;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String? imageUrl;

  PuranModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  factory PuranModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PuranModel(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  static PuranModel? fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (!doc.exists) return null;
    final data = doc.data()!;
    return PuranModel(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }
}
