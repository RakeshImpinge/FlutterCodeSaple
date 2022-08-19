import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/shabad.dart';
import '../../services/repository.dart';
import 'shabad_event.dart';
import 'shabad_state.dart';

class ShabadBloc extends Bloc<ShabadEvent, ShabadState> {
  final Repository _repository;
  ShabadBloc(this._repository) : super(const ShabadListInitial()) {
    on<ShabadListFetched>(
      (event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(ShabadListFetching(state.data, (state is ShabadListInitial)));
          List<ShabadDataItem> result = await _repository.fetchShabadList();
          final data = [...state.data, ...result];
          final hasReachedMaximum = result.isEmpty;
          emit(ShabadListFetchSuccess(data, hasReachedMaximum));
         } catch (e) {
          emit(ShabadListFetchFailure(state.data,
            state.hasReachedMaximum,
            e,
          ));
        }
      },
    );
  }
}
