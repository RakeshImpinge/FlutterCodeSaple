import 'package:equatable/equatable.dart';
import 'package:learn_shudh_gurbani/models/pothi_sahib_data.dart';

abstract class PothiSahibState extends Equatable {
  @override
  List<Object> get props => [];
}

class PothiSahibInitial extends PothiSahibState {
}

class PothiSahibLoaded extends PothiSahibState {
  final List<PothiSahibData> data;
  PothiSahibLoaded({required this.data});
}

class Error extends PothiSahibState {
  final String message;
  Error({required this.message});
}