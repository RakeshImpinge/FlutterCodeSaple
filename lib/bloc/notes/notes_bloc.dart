import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import '../../models/note_data_item.dart';
import '../../services/repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final Repository _repository;
  NotesBloc(this._repository,[NoteDataItem? noteDataItem, int? folderId]) : super(const NotesListInitial()) {
    on<NotesListFetched>((event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(NotesListFetching(state.data, (state is NotesListInitial)));
          List<NoteDataItem> result = await _repository.getNotesList(folderId);
          final data = [...state.data, ...result];
          final hasReachedMaximum = result.isEmpty;
          print("dataNotes>>${result.length}");
          emit(NotesListFetchSuccess(data, hasReachedMaximum));
        } catch (e) {
          emit(NotesListFetchFailure(
            state.data,
            state.hasReachedMaximum,
            e,
          ));
        }
      },
    );
    // on<AddToNote>((event, emit) async {
    //   try {
    //     int data = await _repository.addToNotes(noteDataItem!);
    //     emit(AddToNote(result: data));
    //   } catch(e) {
    //     emit(NotesListFetchFailure(
    //       state.data,
    //       state.hasReachedMaximum,
    //       e,
    //     ));
    //   }
    // });
    on<ArchiveDataItem>((event, emit) async {
      try {
        int responseCode = await _repository.deleteFolderRecord(noteDataItem!.id!,Strings.note);
        if (responseCode == 1) {
          emit(NotesListFetching(state.data, (state is NotesListInitial)));
          List<NoteDataItem> result = await _repository.getNotesList(folderId);
          final data = [...state.data, ...result];
          final hasReachedMaximum = result.isEmpty;
          emit(NotesListFetchSuccess(data, hasReachedMaximum));
        } else {
          emit(NotesListFetchFailure(
            state.data,
            state.hasReachedMaximum, Strings.unable_to_archive_data,
          ));
        }
      } on Exception {
        emit(NotesListFetchFailure(
          state.data,
          state.hasReachedMaximum,
          Strings.unable_to_archive_data,
        ));
      }
    });
  }
}
