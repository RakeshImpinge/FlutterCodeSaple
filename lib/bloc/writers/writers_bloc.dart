
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/writers.dart';
import '../../services/repository.dart';
import '../../strings.dart';
import 'writers_event.dart';
import 'writers_state.dart';

class WritersBloc extends Bloc<WritersEvent, WritersState> {
  final Repository _repository;
  WritersBloc(this._repository,[int? writerId]) : super(WritersInitial()) {
    on<WritersEvent>((event, emit) async {
      try {
        List<WritersModel> data = await _repository.fetchWriterList();
        emit(WritersLoaded(data: data));
      } on Exception {
        emit(Error(message: Strings.unable_to_fetch_data));
      }
    });
    on<WriterNameFetched>((event, emit) async {
      try {
        List<WritersModel> data = await _repository.getWriterName(writerId!);
        emit(WritersLoaded(data: data));
      } on Exception {
        emit(Error(message: Strings.unable_to_fetch_data));
      }
    });
  }
}