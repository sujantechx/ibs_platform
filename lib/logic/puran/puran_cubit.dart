// lib/logic/puran/puran_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/puran_repository.dart';
import 'puran_state.dart';

class PuranCubit extends Cubit<PuranState> {
  final PuranRepository _puranRepository;

  PuranCubit({required PuranRepository puranRepository})
      : _puranRepository = puranRepository,
        super(PuranInitial());

  /// Fetches the list of all purans.
  Future<void> loadPurans() async {
    emit(PuranLoading());
    try {
      final purans = await _puranRepository.getPurans();
      emit(PuransLoaded(purans));
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Fetches subjects for a given puran.
  Future<void> loadSubjects({required String puranId}) async {
    emit(PuranLoading());
    try {
      final subjects = await _puranRepository.getSubjects(puranId: puranId);
      emit(SubjectsLoaded(subjects));
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Fetches chapters for a given subject.
  Future<void> loadChapters({required String puranId, required String subjectId}) async {
    emit(PuranLoading());
    try {
      final chapters = await _puranRepository.getChapters(puranId: puranId, subjectId: subjectId);
      emit(ChaptersLoaded(chapters));
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Adds a new puran.
  Future<void> addPuran({required String title, required String description}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.addPuran(title: title, description: description);
      emit(PuranSuccess('Puran added successfully!'));
      loadPurans(); // Refresh the list
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Updates a puran.
  Future<void> updatePuran({required String puranId, required Map<String, dynamic> data}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.updatePuran(puranId: puranId, data: data);
      emit(PuranSuccess('Puran updated successfully!'));
      loadPurans(); // Refresh the list
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Deletes a puran.
  Future<void> deletePuran({required String puranId}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.deletePuran(puranId: puranId);
      emit(PuranSuccess('Puran deleted successfully!'));
      loadPurans(); // Refresh the list
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Adds a subject.
  Future<void> addSubject({required String puranId, required String title, required String description}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.addSubject(puranId: puranId, title: title, description: description);
      emit(PuranSuccess('Subject added successfully!'));
      loadSubjects(puranId: puranId); // Refresh
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Updates a subject.
  Future<void> updateSubject({required String puranId, required String subjectId, required Map<String, dynamic> data}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.updateSubject(puranId: puranId, subjectId: subjectId, data: data);
      emit(PuranSuccess('Subject updated successfully!'));
      loadSubjects(puranId: puranId); // Refresh
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Deletes a subject.
  Future<void> deleteSubject({required String puranId, required String subjectId}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.deleteSubject(puranId: puranId, subjectId: subjectId);
      emit(PuranSuccess('Subject deleted successfully!'));
      loadSubjects(puranId: puranId); // Refresh
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Adds a chapter.
  Future<void> addChapter({required String puranId, required String subjectId, required String title}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.addChapter(puranId: puranId, subjectId: subjectId, title: title);
      emit(PuranSuccess('Chapter added successfully!'));
      loadChapters(puranId: puranId, subjectId: subjectId); // Refresh
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Updates a chapter.
  Future<void> updateChapter({required String puranId, required String subjectId, required String chapterId, required Map<String, dynamic> data}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.updateChapter(puranId: puranId, subjectId: subjectId, chapterId: chapterId, data: data);
      emit(PuranSuccess('Chapter updated successfully!'));
      loadChapters(puranId: puranId, subjectId: subjectId); // Refresh
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  /// Deletes a chapter.
  Future<void> deleteChapter({required String puranId, required String subjectId, required String chapterId}) async {
    emit(PuranLoading());
    try {
      await _puranRepository.deleteChapter(puranId: puranId, subjectId: subjectId, chapterId: chapterId);
      emit(PuranSuccess('Chapter deleted successfully!'));
      loadChapters(puranId: puranId, subjectId: subjectId); // Refresh
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }
}
