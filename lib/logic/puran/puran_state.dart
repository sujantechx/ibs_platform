// lib/logic/puran/puran_state.dart

import '../../../data/models/chapter_model.dart';
import '../../../data/models/puran_model.dart';
import '../../../data/models/subject_model.dart';

abstract class PuranState {}

class PuranInitial extends PuranState {}

class PuranLoading extends PuranState {}

class PuransLoaded extends PuranState {
  final List<PuranModel> purans;

  PuransLoaded(this.purans);
}

class SubjectsLoaded extends PuranState {
  final List<SubjectModel> subjects;

  SubjectsLoaded(this.subjects);
}

class ChaptersLoaded extends PuranState {
  final List<ChapterModel> chapters;

  ChaptersLoaded(this.chapters);
}

class PuranError extends PuranState {
  final String message;

  PuranError(this.message);
}
