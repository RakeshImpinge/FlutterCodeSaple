import 'package:flutter/foundation.dart';
import 'package:learn_shudh_gurbani/models/banis.dart';

enum BanisStatus { initial, loading, success, failure }

@immutable
abstract class BanisState {
  final List<BanisModel> data;
  final bool hasReachedMaximum;
  const BanisState({
    this.data = const <BanisModel>[],
    required this.hasReachedMaximum,
  });

  List<Object> get props => [data, hasReachedMaximum];
}

class BanisInitial extends BanisState {
  const BanisInitial() : super(hasReachedMaximum: false);
}

class BanisFetchSuccess extends BanisState {
  const BanisFetchSuccess(
      List<BanisModel> data, bool hasReachedMaximum) : super(data: data, hasReachedMaximum: hasReachedMaximum,
  );
}

class BanisFetchFailure extends BanisState {
  final dynamic exception;
  const BanisFetchFailure(
      List<BanisModel> data,
      bool hasReachedMaximum,
      this.exception,) : super(data: data,
      hasReachedMaximum: hasReachedMaximum,
  );

  @override
  List<Object> get props => [exception.toString()];
}

class BanisFetching extends BanisState {
  final bool isInitial;
  const BanisFetching(
      List<BanisModel> data,
      this.isInitial,) : super(
      hasReachedMaximum: false,
      data: data,
  );
}
