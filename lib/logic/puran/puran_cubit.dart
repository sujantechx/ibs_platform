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
}
