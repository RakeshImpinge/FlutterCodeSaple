import 'package:equatable/equatable.dart';

abstract class TrackersEvent extends Equatable {
  const TrackersEvent();
  @override
  List<Object> get props => [];
}

class NameChanged extends TrackersEvent {
  const NameChanged({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}
class TrackerNameUnfocused extends TrackersEvent {}

class TrackersSubmission extends TrackersEvent {}

class FormSubmitted extends TrackersEvent {}
