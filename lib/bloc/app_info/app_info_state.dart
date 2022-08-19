
import 'package:flutter/foundation.dart';

import '../../models/app_info_data.dart';
enum AppInfoStatus { initial, loading, success, failure }

@immutable
abstract class AppInfoState {
  final List<AppInfoData> data;
  final bool hasReachedMaximum;
  const AppInfoState({
    this.data = const <AppInfoData>[],
    required this.hasReachedMaximum,
  });

  List<Object> get props => [data, hasReachedMaximum];
}

class AppInfoInitial extends AppInfoState {
  const AppInfoInitial() : super(hasReachedMaximum: false);
}

class AppInfoFetchSuccess extends AppInfoState {
  const AppInfoFetchSuccess(
    List<AppInfoData> data,
    bool hasReachedMaximum,
  ) : super(
    data: data,
          hasReachedMaximum: hasReachedMaximum,
        );
}

class AppInfoFetchFailure extends AppInfoState {
  final dynamic exception;

  const AppInfoFetchFailure(
    List<AppInfoData> data,
    bool hasReachedMaximum,
    this.exception,
  ) : super(
    data: data,
          hasReachedMaximum: hasReachedMaximum,
        );

  @override
  List<Object> get props => [exception.toString()];
}

class AppInfoFetching extends AppInfoState {
  final bool isInitial;
  const AppInfoFetching(
    List<AppInfoData> data,
    this.isInitial,
  ) : super(
          hasReachedMaximum: false,
    data: data);
}
