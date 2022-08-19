import 'package:equatable/equatable.dart';

abstract class RaagEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RaagFetched extends RaagEvent {}