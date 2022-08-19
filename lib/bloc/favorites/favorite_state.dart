
import 'package:flutter/foundation.dart';
import '../../models/favorite_data_item.dart';

enum FavoriteListStatus { initial, loading, success, failure }

@immutable
abstract class FavoriteState {
  final List<FavoriteDataItem> data;
  final bool hasReachedMaximum;
  const FavoriteState({
    this.data = const <FavoriteDataItem>[],
    required this.hasReachedMaximum,
  });

  List<Object> get props => [data, hasReachedMaximum];
}

class FavoriteListInitial extends FavoriteState {
  const FavoriteListInitial() : super(hasReachedMaximum: false);
}

class FavoriteListFetchSuccess extends FavoriteState {
  const FavoriteListFetchSuccess(
    List<FavoriteDataItem> data,
    bool hasReachedMaximum,
  ) : super(
    data: data, hasReachedMaximum: hasReachedMaximum);
}

class FavoriteListFetchFailure extends FavoriteState {
  final dynamic exception;

  const FavoriteListFetchFailure(
    List<FavoriteDataItem> data,
    bool hasReachedMaximum,
    this.exception,
  ) : super(
    data: data,
    hasReachedMaximum: hasReachedMaximum,);

  @override
  List<Object> get props => [exception.toString()];
}

class FavoriteListFetching extends FavoriteState {
  final bool isInitial;
  const FavoriteListFetching(
    List<FavoriteDataItem> data,
    this.isInitial,) : super(
    hasReachedMaximum: false,
    data: data);
}

class AddToFavorite extends FavoriteState {
  final int result;
  const AddToFavorite({required this.result}) : super(hasReachedMaximum: false);
}
