
import 'package:flutter/foundation.dart';

import '../../models/shabad.dart';

enum ShabadListStatus { initial, loading, success, failure }

@immutable
abstract class ShabadState {
  final List<ShabadDataItem> data;
  final bool hasReachedMaximum;
  const ShabadState({
    this.data = const <ShabadDataItem>[],
    required this.hasReachedMaximum,
  });

  List<Object> get props => [data, hasReachedMaximum];
}

class ShabadListInitial extends ShabadState {
  const ShabadListInitial() : super(hasReachedMaximum: false);
}

class ShabadListFetchSuccess extends ShabadState {
  const ShabadListFetchSuccess(
    List<ShabadDataItem> data,
    bool hasReachedMaximum,
  ) : super(
    data: data,
          hasReachedMaximum: hasReachedMaximum,
        );
}

class ShabadListFetchFailure extends ShabadState {
  final dynamic exception;

  const ShabadListFetchFailure(
    List<ShabadDataItem> data,
    bool hasReachedMaximum,
    this.exception,
  ) : super(
    data: data,
          hasReachedMaximum: hasReachedMaximum,
        );

  @override
  List<Object> get props => [exception.toString()];
}

class ShabadListFetching extends ShabadState {
  final bool isInitial;
  const ShabadListFetching(
    List<ShabadDataItem> data,
    this.isInitial,
  ) : super(
          hasReachedMaximum: false,
    data: data,
        );
}
