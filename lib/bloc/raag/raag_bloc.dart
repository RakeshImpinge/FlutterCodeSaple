
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/raag_data.dart';
import '../../services/repository.dart';
import 'raag_event.dart';
import 'raag_state.dart';

class RaagBloc extends Bloc<RaagEvent, RaagState> {
  final Repository _repository;
  RaagBloc(this._repository) : super(RaagInitial()) {
    on<RaagEvent>((event, emit) async {
      try {
        List<RaagModel> data = await _repository.fetchRaagList();
        emit(RaagLoaded(data: data));
      } on Exception {
        emit(Error(message: "Couldn't fetch the list, please try again later!"));
      }
    });
  }
}