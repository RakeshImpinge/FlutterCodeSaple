import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import '../../models/favorite_data_item.dart';
import '../../services/repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final Repository _repository;
  FavoriteBloc(this._repository,[FavoriteDataItem? favoriteDataItem, int? folderId]) : super(const FavoriteListInitial()) {
    on<FavoriteListFetched>((event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(FavoriteListFetching(state.data, (state is FavoriteListInitial)));
          List<FavoriteDataItem> result = await _repository.fetchFavoriteList(folderId);
          final data = [...state.data, ...result];
          final hasReachedMaximum = result.isEmpty;
          emit(FavoriteListFetchSuccess(data, hasReachedMaximum));
        } catch (e) {
          emit(FavoriteListFetchFailure(
            state.data,
            state.hasReachedMaximum,
            e,
          ));
        }
      },
    );
    on<AddToFavorites>((event, emit) async {
      try {
        int data = await _repository.addToFavoriteList(favoriteDataItem!);
        emit(AddToFavorite(result: data));
      } catch(e) {
        emit(FavoriteListFetchFailure(
          state.data,
          state.hasReachedMaximum,
          e,
        ));
      }
    });
    on<ArchiveDataItem>((event, emit) async {
      try {
        int responseCode = await _repository.deleteFolderRecord(favoriteDataItem!.folder_id!,Strings.favorites);
        if (responseCode == 1) {
          emit(FavoriteListFetching(state.data, (state is FavoriteListInitial)));
          List<FavoriteDataItem> result = await _repository.fetchFavoriteList(folderId);
          final data = [...state.data, ...result];
          final hasReachedMaximum = result.isEmpty;
          emit(FavoriteListFetchSuccess(data, hasReachedMaximum));
        } else {
          emit(FavoriteListFetchFailure(
            state.data,
            state.hasReachedMaximum, Strings.unable_to_archive_data,
          ));
        }
      } on Exception {
        emit(FavoriteListFetchFailure(
          state.data,
          state.hasReachedMaximum,
         Strings.unable_to_archive_data,
        ));
      }
    });
  }
}
