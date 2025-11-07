import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibs_platform/japa_counter/bloc/japa_state.dart';
import 'package:ibs_platform/japa_counter/data/repositories/japa_repository.dart';

class JapaCubit extends Cubit<JapaState> {
  final JapaRepository japaRepository;

  JapaCubit({required this.japaRepository}) : super(JapaInitial());

  void getJapaCount() async {
    try {
      emit(JapaLoading());
      final japaCount = await japaRepository.getJapaCount();
      emit(JapaLoaded(japaCount));
    } catch (e) {
      emit(JapaError(e.toString()));
    }
  }
}

