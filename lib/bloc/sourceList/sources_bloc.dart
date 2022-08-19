import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/models/sources.dart';
import '../../services/repository.dart';
import '../../strings.dart';
import 'sources_event.dart';
import 'sources_state.dart';

class SourcesBloc extends Bloc<SourcesEvent, SourcesState> {
  final Repository _repository;
  SourcesBloc(this._repository) : super(SourcesInitial()) {
    on<SourcesEvent>((event, emit) async {
      try {
        List<SourcesModel> data = await _repository.fetchSourceList();
        emit(SourcesLoaded(data: data));
      } on Exception {
        emit(Error(message: Strings.unable_to_fetch_data));
      }
    });

  }
}