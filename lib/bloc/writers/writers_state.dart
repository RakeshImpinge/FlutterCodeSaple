import 'package:equatable/equatable.dart';
import 'package:learn_shudh_gurbani/models/writers.dart';
abstract class WritersState extends Equatable {
  @override
  List<Object> get props => [];
}

class WritersInitial extends WritersState {
}

class WritersLoaded extends WritersState {
  final List<WritersModel> data;
  WritersLoaded({required this.data});
}

class Error extends WritersState {
  final String message;
  Error({required this.message});
}