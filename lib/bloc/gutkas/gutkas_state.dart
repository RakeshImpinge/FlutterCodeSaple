import 'package:flutter/foundation.dart';
import 'package:learn_shudh_gurbani/models/gutkas.dart';

enum GutkasListStatus { initial, loading, success, failure }

@immutable
abstract class GutkasState {
  final List<GutkasModel> data;
  final bool hasReachedMaximum;
  const GutkasState({this.data = const <GutkasModel>[], required this.hasReachedMaximum,});

  List<Object> get props => [data, hasReachedMaximum];
}

class GutkasListInitial extends GutkasState {
  const GutkasListInitial() : super(hasReachedMaximum: false);
}

class GutkasListFetchSuccess extends GutkasState {
  const GutkasListFetchSuccess(List<GutkasModel> data, bool hasReachedMaximum,) : super(data: data, hasReachedMaximum: hasReachedMaximum);
}

class GutkasListFetchFailure extends GutkasState {
  final dynamic exception;
  const GutkasListFetchFailure(List<GutkasModel> data, bool hasReachedMaximum,
    this.exception) : super(data: data, hasReachedMaximum: hasReachedMaximum);

  @override
  List<Object> get props => [exception.toString()];
}

class GutkasListFetching extends GutkasState {
  final bool isInitial;
  const GutkasListFetching(List<GutkasModel> data, this.isInitial) : super(hasReachedMaximum: false, data: data);
}
