import 'package:equatable/equatable.dart';
import '../../models/sources.dart';
abstract class SourcesState extends Equatable {
  @override
  List<Object> get props => [];
}

class SourcesInitial extends SourcesState {
}

class SourcesLoaded extends SourcesState {
  final List<SourcesModel> data;
  SourcesLoaded({required this.data});
}

class Error extends SourcesState {
  final String message;
  Error({required this.message});
}