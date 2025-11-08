import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/vaishnav_puran/bloc/puran_state.dart';
import 'package:ibs_platform/vaishnav_puran/data/repositories/puran_repository.dart';

class PuranCubit extends Cubit<PuranState> {
  final PuranRepository puranRepository;

  PuranCubit({required this.puranRepository}) : super(PuranInitial());

  void getPurans() async {
    try {
      emit(PuranLoading());
      final purans = await puranRepository.getPurans();
      emit(PuranLoaded(purans));
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  Future<void> getSubjects(String puranId) async {
    try {
      emit(PuranLoading());
      final subjects = await puranRepository.getSubjects(puranId);
      emit(PuranSubjectsLoaded(puranId, subjects));
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  Future<void> getChapters(String puranId, String subjectId) async {
    try {
      emit(PuranLoading());
      final chapters = await puranRepository.getChapters(puranId, subjectId);
      emit(PuranChaptersLoaded(puranId, subjectId, chapters));
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }

  Future<void> getChapter(String puranId, String subjectId, String chapterId) async {
    try {
      emit(PuranLoading());
      final chapter = await puranRepository.getChapter(puranId, subjectId, chapterId);
      emit(PuranChapterLoaded(puranId, subjectId, chapter));
    } catch (e) {
      emit(PuranError(e.toString()));
    }
  }
}
