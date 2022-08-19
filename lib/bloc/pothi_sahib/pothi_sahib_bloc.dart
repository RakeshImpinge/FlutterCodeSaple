import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/models/pothi_sahib_data.dart';
import '../../services/repository.dart';
import 'pothi_sahib_event.dart';
import 'pothi_sahib_state.dart';
class PothiSahibBloc extends Bloc<PothiSahibEvent, PothiSahibState> {
  final Repository _repository;
  PothiSahibBloc(this._repository) : super(PothiSahibInitial()) {
    on<PothiSahibEvent>((event, emit) async {
      try {
        List<PothiSahibData> data = await _repository.fetchPothiSahibList();
        emit(PothiSahibLoaded(data: data));
      } on Exception {
        emit(Error(message: "Couldn't fetch the list, please try again later!"));
      }
    });
  }
}