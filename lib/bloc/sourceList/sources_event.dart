import 'package:equatable/equatable.dart';

abstract class SourcesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SourcesFetched extends SourcesEvent {}
