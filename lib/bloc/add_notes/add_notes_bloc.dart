import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/models/note_data_item.dart';
import '../../services/repository.dart';
import '../../strings.dart';
import 'add_notes_event.dart';
import 'add_notes_state.dart';

class AddNotesBloc extends Bloc<AddNotesEvent, AddNotesState> {
  final Repository _repository;
  AddNotesBloc(this._repository,[NoteDataItem? noteDataItem, int? folderId]) : super(NotesInitial()) {
    on<AddNotesEvent>((event, emit) async {
      try {
        List<NoteDataItem> data = await _repository.getNotesList(folderId);
        emit(NotesLoaded(data: data));
      } on Exception {
        emit(Error(message: Strings.unable_to_fetch_data));
      }
    });
  }
}
