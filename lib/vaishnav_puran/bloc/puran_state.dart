import 'package:equatable/equatable.dart';
import 'package:ibs_platform/vaishnav_puran/data/models/puran_list.dart';
import 'package:ibs_platform/vaishnav_puran/data/models/puran_subject.dart';
import 'package:ibs_platform/vaishnav_puran/data/models/puran_chapter.dart';

abstract class PuranState extends Equatable {
  const PuranState();

  @override
  List<Object> get props => [];
}

class PuranInitial extends PuranState {}

class PuranLoading extends PuranState {}

class PuranLoaded extends PuranState {
  final List<Puran> purans;

  const PuranLoaded(this.purans);

  @override
  List<Object> get props => [purans];
}

class PuranSubjectsLoaded extends PuranState {
  final String puranId;
  final List<PuranSubject> subjects;

  const PuranSubjectsLoaded(this.puranId, this.subjects);

  @override
  List<Object> get props => [puranId, subjects];
}

class PuranChaptersLoaded extends PuranState {
  final String puranId;
  final String subjectId;
  final List<PuranChapter> chapters;

  const PuranChaptersLoaded(this.puranId, this.subjectId, this.chapters);

  @override
  List<Object> get props => [puranId, subjectId, chapters];
}

class PuranChapterLoaded extends PuranState {
  final String puranId;
  final String subjectId;
  final PuranChapter chapter;

  const PuranChapterLoaded(this.puranId, this.subjectId, this.chapter);

  @override
  List<Object> get props => [puranId, subjectId, chapter];
}

class PuranError extends PuranState {
  final String message;

  const PuranError(this.message);

  @override
  List<Object> get props => [message];
}
