
import 'package:equatable/equatable.dart';

abstract class ReportMistakeEvent extends Equatable {
  const ReportMistakeEvent();

  @override
  List<Object> get props => [];
}

class TrackNameChanged extends ReportMistakeEvent {
  const TrackNameChanged({required this.trackName});

  final String trackName;

  @override
  List<Object> get props => [trackName];
}
class AngChanged extends ReportMistakeEvent {
  const AngChanged({required this.ang});

  final String ang;

  @override
  List<Object> get props => [ang];
}
class TrackDurationChanged extends ReportMistakeEvent {
  const TrackDurationChanged({required this.duration});

  final String duration;

  @override
  List<Object> get props => [duration];
}
class MessageChanged extends ReportMistakeEvent {
  const MessageChanged({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
class GurbaniTukChanged extends ReportMistakeEvent {
  const GurbaniTukChanged({required this.gurbaniTuk});

  final String gurbaniTuk;

  @override
  List<Object> get props => [gurbaniTuk];
}

class EmailUnfocused extends ReportMistakeEvent {}

class PasswordChanged extends ReportMistakeEvent {
  const PasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswordUnfocused extends ReportMistakeEvent {}

class FormSubmitted extends ReportMistakeEvent {}
