import 'package:equatable/equatable.dart';
import 'package:learn_shudh_gurbani/models/folder_model.dart';

abstract class FolderState extends Equatable {
  @override
  List<Object> get props => [];
}

class FolderInitial extends FolderState {
}

class FolderLoaded extends FolderState {
  final List<FolderModel> data;
  FolderLoaded({required this.data});
}
class FolderCreated extends FolderState {
    var data;
    FolderCreated({required this.data});
}

class Error extends FolderState {
  final String message;
  Error({required this.message});
}
