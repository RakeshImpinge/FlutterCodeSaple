
import 'package:equatable/equatable.dart';

class FolderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FolderFetched extends FolderEvent {}
class FolderCreated extends FolderEvent {}
