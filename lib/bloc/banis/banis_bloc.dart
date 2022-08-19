import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/models/banis.dart';
import '../../services/repository.dart';
import 'banis_event.dart';
import 'banis_state.dart';

class BanisBloc extends Bloc<BanisEvent, BanisState> {
  final Repository _repository;
  BanisBloc(this._repository,[inputValue]) : super(const BanisInitial()) {
    on<BanisFetched>(
          (event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(BanisFetching(state.data, (state is BanisInitial)));
          List<BanisModel> result = await _repository.fetchBanisList();
         // List<BanisModel> list=[];
          // if(inputValue!="" && inputValue!=null){
          //  var valur= result.where((element) => element.english.contains(inputValue));
          //  // print("value>>$valur");
          //  //list.add(valur);
          //  final data = [...state.data, ...valur];
          //  print("value>>$data");
          //  final hasReachedMaximum = valur.isEmpty;
          //  emit(BanisFetchSuccess(data, hasReachedMaximum));
          //   //print(result.where((score) => score. 1).toList());
          // }else {
            final data = [...state.data, ...result];
            final hasReachedMaximum = result.isEmpty;
            emit(BanisFetchSuccess(data, hasReachedMaximum));
         // }

        } catch (e) {
          emit(BanisFetchFailure(state.data,
            state.hasReachedMaximum,
            e,
          ));
        }
      },
    );

    /*
    Search bani method
     */

    on<SearchBanisFetched>(
          (event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(BanisFetching(state.data, (state is BanisInitial)));
          List<BanisModel> result = await _repository.fetchSearchBanisList(inputValue);
          // List<BanisModel> list=[];
          // if(inputValue!="" && inputValue!=null){
          //  var valur= result.where((element) => element.english.contains(inputValue));
          //  // print("value>>$valur");
          //  //list.add(valur);
          //  final data = [...state.data, ...valur];
          //  print("value>>$data");
          //  final hasReachedMaximum = valur.isEmpty;
          //  emit(BanisFetchSuccess(data, hasReachedMaximum));
          //   //print(result.where((score) => score. 1).toList());
          // }else {
          final data = [...state.data, ...result];
          final hasReachedMaximum = result.isEmpty;
          emit(BanisFetchSuccess(data, hasReachedMaximum));
          // }

        } catch (e) {
          emit(BanisFetchFailure(state.data,
            state.hasReachedMaximum,
            e,
          ));
        }
      },
    );

  }
}
