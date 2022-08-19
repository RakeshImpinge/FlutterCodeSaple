import 'package:equatable/equatable.dart';

abstract class WritersEvent extends Equatable {
  @override
  List<Object> get props => [];
}



class WritersFetched extends WritersEvent {}

class WriterNameFetched extends WritersEvent {}