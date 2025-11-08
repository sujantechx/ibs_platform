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
  /// Adds a new puran.
  Future<void> addPuran({required String title, required String description}) async {
    try {
      await _puransRef().add({
        'title': title,
        'description': description,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      developer.log("Error adding puran: $e");
      throw Exception('Failed to add puran.');
    }
  }

  /// Updates an existing puran.
  Future<void> updatePuran({required String puranId, required Map<String, dynamic> data}) async {
    try {
      await _puransRef().doc(puranId).update(data);
    } catch (e) {
      developer.log("Error updating puran: $e");
      throw Exception('Failed to update puran.');
    }
  }

  /// Deletes a puran.
  Future<void> deletePuran({required String puranId}) async {
    try {
      await _puransRef().doc(puranId).delete();
    } catch (e) {
      developer.log("Error deleting puran: $e");
      throw Exception('Failed to delete puran.');
    }
  }

  /// Adds a new subject to a puran.
  Future<void> addSubject({required String puranId, required String title, required String description}) async {
    try {
      await _puransRef().doc(puranId).collection('subjects').add({
        'title': title,
        'description': description,
        'subjectNumber': 0, // or calculate
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      developer.log("Error adding subject: $e");
      throw Exception('Failed to add subject.');
    }
  }

  /// Updates a subject.
  Future<void> updateSubject({required String puranId, required String subjectId, required Map<String, dynamic> data}) async {
    try {
      await _puransRef().doc(puranId).collection('subjects').doc(subjectId).update(data);
    } catch (e) {
      developer.log("Error updating subject: $e");
      throw Exception('Failed to update subject.');
    }
  }

  /// Deletes a subject.
  Future<void> deleteSubject({required String puranId, required String subjectId}) async {
    try {
      await _puransRef().doc(puranId).collection('subjects').doc(subjectId).delete();
    } catch (e) {
      developer.log("Error deleting subject: $e");
      throw Exception('Failed to delete subject.');
    }
  }

  /// Adds a new chapter to a subject.
  Future<void> addChapter({required String puranId, required String subjectId, required String title}) async {
    try {
      await _puransRef().doc(puranId).collection('subjects').doc(subjectId).collection('chapters').add({
        'title': title,
        'chapterNumber': 0,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      developer.log("Error adding chapter: $e");
      throw Exception('Failed to add chapter.');
    }
  }

  /// Updates a chapter.
  Future<void> updateChapter({required String puranId, required String subjectId, required String chapterId, required Map<String, dynamic> data}) async {
    try {
      await _puransRef().doc(puranId).collection('subjects').doc(subjectId).collection('chapters').doc(chapterId).update(data);
    } catch (e) {
      developer.log("Error updating chapter: $e");
      throw Exception('Failed to update chapter.');
    }
  }

  /// Deletes a chapter.
  Future<void> deleteChapter({required String puranId, required String subjectId, required String chapterId}) async {
    try {
      await _puransRef().doc(puranId).collection('subjects').doc(subjectId).collection('chapters').doc(chapterId).delete();
    } catch (e) {
      developer.log("Error deleting chapter: $e");
      throw Exception('Failed to delete chapter.');
    }
  }
}
