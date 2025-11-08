import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibs_platform/vaishnav_puran/data/models/puran_list.dart';
import 'package:ibs_platform/vaishnav_puran/data/models/puran_subject.dart';
import 'package:ibs_platform/vaishnav_puran/data/models/puran_chapter.dart';

class PuranRepository {
  final FirebaseFirestore _firestore;

  PuranRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Top-level collection name
  static const String collection = 'vaishnav_puran';

  Future<List<Puran>> getPurans() async {
    final snap = await _firestore.collection(collection).orderBy('order', descending: false).get();
    return snap.docs.map((d) => Puran.fromMap(d.data(), d.id)).toList();
  }

  Future<List<PuranSubject>> getSubjects(String puranId) async {
    final snap = await _firestore
        .collection(collection)
        .doc(puranId)
        .collection('subjects')
        .orderBy('order', descending: false)
        .get();
    return snap.docs.map((d) => PuranSubject.fromMap(d.data(), d.id)).toList();
  }

  Future<List<PuranChapter>> getChapters(String puranId, String subjectId) async {
    final snap = await _firestore
        .collection(collection)
        .doc(puranId)
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .orderBy('order', descending: false)
        .get();
    return snap.docs.map((d) => PuranChapter.fromMap(d.data(), d.id)).toList();
  }

  Future<PuranChapter> getChapter(String puranId, String subjectId, String chapterId) async {
    final doc = await _firestore
        .collection(collection)
        .doc(puranId)
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId)
        .get();
    return PuranChapter.fromMap(doc.data() ?? {}, doc.id);
  }
}
