import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/models/trackers_data.dart';
import 'package:learn_shudh_gurbani/validate_models/name.dart';

class TrackersState extends Equatable {
  const TrackersState({
    this.name = const Name.pure(),
    this.status = FormzStatus.pure,
  });

  final Name name;
  final FormzStatus status;

  @override
  List<Object> get props => [name, status];
  TrackersState copyWith({
    Name? name,
    FormzStatus? status,
  }) {
    return TrackersState(
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}
class TrackersInitial extends TrackersState {
}
class TrackersSubmitted extends TrackersState {
  final int data;
  TrackersSubmitted({required this.data});
}
class TrackersLoaded extends TrackersState {
  final List<TrackersData> data;
  TrackersLoaded({required this.data});
}

class Error extends TrackersState {
  final String message;
  Error({required this.message});
}