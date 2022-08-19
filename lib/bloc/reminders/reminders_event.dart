import 'package:equatable/equatable.dart';

abstract class RemindersEvent extends Equatable {
  const RemindersEvent();
  @override
  List<Object> get props => [];
}

class NameChanged extends RemindersEvent {
  const NameChanged({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}
class ReminderNameUnfocused extends RemindersEvent {}
class ReminderSubmission extends RemindersEvent {}
class ReminderStatusUpdated extends RemindersEvent {}
class RefreshData extends RemindersEvent {}

class ArchiveReminder extends RemindersEvent{}
class FormSubmitted extends RemindersEvent {}
class ReminderListFetched extends RemindersEvent {}
