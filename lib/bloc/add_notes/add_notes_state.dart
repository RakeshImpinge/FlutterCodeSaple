import 'package:equatable/equatable.dart';
import '../../models/note_data_item.dart';

 class AddNotesState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotesInitial extends AddNotesState {
}

class NotesLoaded extends AddNotesState {
  final List<NoteDataItem> data;
  NotesLoaded({required this.data});
}

class Error extends AddNotesState {
  final String message;
  Error({required this.message});
}
// {
//   String? defaultFolderName;
//   int? counterValues;
//   bool? dropDownValue;
//   AddNotesState({this.defaultFolderName,this.counterValues,this.dropDownValue});
// }