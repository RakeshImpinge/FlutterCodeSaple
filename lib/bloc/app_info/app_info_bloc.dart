import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/models/app_info_data.dart';
import '../../services/repository.dart';
import 'app_info_event.dart';
import 'app_info_state.dart';
class AppInfoBloc extends Bloc<AppInfoEvent, AppInfoState> {
  final Repository _repository;
  AppInfoBloc(this._repository,  int? sectionId,int? index) : super(const AppInfoInitial()) {
    on<AppInfoFetched>(
      (event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(AppInfoFetching(state.data, (state is AppInfoInitial)));
         Iterable<AppInfoData> result = await _repository.fetchAppInfo(sectionId,index);
          final data = [...state.data, ...result];
          final hasReachedMaximum = result.isEmpty;
          emit(AppInfoFetchSuccess(data, hasReachedMaximum));
        } catch (e) {
          emit(AppInfoFetchFailure(
            state.data,
            state.hasReachedMaximum,
            e,
          ));
        }
      },
    );
  }
}
