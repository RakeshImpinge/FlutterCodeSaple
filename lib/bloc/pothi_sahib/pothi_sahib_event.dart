import 'package:equatable/equatable.dart';

abstract class PothiSahibEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PothiSahibFetched extends PothiSahibEvent {}