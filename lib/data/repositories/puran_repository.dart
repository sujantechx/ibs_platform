// lib/data/repositories/puran_repository.dart

import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chapter_model.dart';
import '../models/puran_model.dart';
import '../models/subject_model.dart';

class PuranRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper to get the base collection reference
  CollectionReference _puransRef() => _firestore.collection('vaishnav_puran');

  /// Fetches a list of all purans.
  Future<List<PuranModel>> getPurans() async {
    try {
      final snapshot = await _puransRef().get();
      return snapshot.docs.map((doc) => PuranModel.fromSnapshot(doc)).toList();
    } catch (e) {
      developer.log("Error fetching purans: $e");
      throw Exception('Failed to load purans.');
    }
  }

  /// Fetches all subjects for a given puran.
  Future<List<SubjectModel>> getSubjects({required String puranId}) async {
    try {
      final snapshot = await _puransRef().doc(puranId).collection('subjects').get();
      return snapshot.docs.map((doc) => SubjectModel.fromSnapshot(doc)).toList();
    } catch (e) {
      developer.log("Error fetching subjects: $e");
      throw Exception('Failed to load subjects.');
    }
  }

  /// Fetches all chapters for a given subject.
  Future<List<ChapterModel>> getChapters(
      {required String puranId, required String subjectId}) async {
    try {
      final snapshot = await _puransRef()
          .doc(puranId)
          .collection('subjects')
          .doc(subjectId)
          .collection('chapters')
          .get();
      return snapshot.docs.map((doc) => ChapterModel.fromSnapshot(doc)).toList();
    } catch (e) {
      developer.log("Error fetching chapters: $e");
      throw Exception('Failed to load chapters.');
    }
  }

  // Add more methods as needed for videos, pdfs, etc., similar to admin_repository
}
