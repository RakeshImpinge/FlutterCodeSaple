
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/models/gutkas.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../services/repository.dart';
import 'gutkas_event.dart';
import 'gutkas_state.dart';
class GutkasBloc extends Bloc<GutkasEvent, GutkasState> {
  final Repository _repository;
  GutkasBloc(this._repository, [int? gutkaId]) : super(const GutkasListInitial()) {
    on<GutkasListFetched>(
      (event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(GutkasListFetching(state.data, (state is GutkasListInitial)));
          List<GutkasModel> result = await _repository.fetchGutkasList();
          final data = [...state.data, ...result];
          final hasReachedMaximum = result.isEmpty;
          emit(GutkasListFetchSuccess(data,hasReachedMaximum));
        } catch (e) {
          emit(GutkasListFetchFailure(state.data, state.hasReachedMaximum, e,));
        }
      },
    );
    // return Gukta Sub Bani List according selected bani from Sundar Gutka List
    on<GutkasSubBaniListFetched>((event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(GutkasListFetching(state.data, (state is GutkasListInitial)));
          List<GutkasModel>? result = await _repository.getGutkasSubBaniList(gutkaId);
          final data = [...state.data, ...?result];
       //   final hasReachedMaximum = result.isEmpty;
          emit(GutkasListFetchSuccess(data,false));
        } catch (e) {
          emit(GutkasListFetchFailure(state.data, state.hasReachedMaximum,e,
          ));
        }
      },
    );
  }
}
