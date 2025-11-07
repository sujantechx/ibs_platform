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
}

