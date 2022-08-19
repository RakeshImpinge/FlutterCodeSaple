import 'package:equatable/equatable.dart';
import 'package:learn_shudh_gurbani/models/raag_data.dart';

abstract class RaagState extends Equatable {
  @override
  List<Object> get props => [];
}

class RaagInitial extends RaagState {
}

class RaagLoaded extends RaagState {
  final List<RaagModel> data;
  RaagLoaded({required this.data});
}

class Error extends RaagState {
  final String message;
  Error({required this.message});
}