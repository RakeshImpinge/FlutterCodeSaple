
import 'package:flutter/foundation.dart';

import '../../models/note_data_item.dart';

enum NotesListStatus { initial, loading, success, failure }

@immutable
abstract class NotesState {
  final List<NoteDataItem> data;
  final bool hasReachedMaximum;
  const NotesState({
    this.data = const <NoteDataItem>[],
    required this.hasReachedMaximum,
  });

  List<Object> get props => [data, hasReachedMaximum];
}

class NotesListInitial extends NotesState {
  const NotesListInitial() : super(hasReachedMaximum: false);
}

class NotesListFetchSuccess extends NotesState {
  const NotesListFetchSuccess(
    List<NoteDataItem> data,
    bool hasReachedMaximum,
  ) : super(
    data: data, hasReachedMaximum: hasReachedMaximum);
}

class NotesListFetchFailure extends NotesState {
  final dynamic exception;

  const NotesListFetchFailure(
    List<NoteDataItem> data,
    bool hasReachedMaximum,
    this.exception,
  ) : super(
    data: data,
    hasReachedMaximum: hasReachedMaximum,);

  @override
  List<Object> get props => [exception.toString()];
}

class NotesListFetching extends NotesState {
  final bool isInitial;
  const NotesListFetching(
    List<NoteDataItem> data,
    this.isInitial,) : super(
    hasReachedMaximum: false,
    data: data);
}

class AddToNote extends NotesState {
  final int result;
  const AddToNote({required this.result}) : super(hasReachedMaximum: false);
}
