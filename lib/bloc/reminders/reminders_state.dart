import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/models/create_reminders_data.dart';
import 'package:learn_shudh_gurbani/validate_models/name.dart';

enum ReminderListStatus { initial, loading, success, failure }

@immutable
class RemindersState extends Equatable {
  final List<RemindersData> data;
  RemindersState({
    this.name = const Name.pure(),
    this.status = FormzStatus.pure,
    this.data = const <RemindersData>[],
  });

  final Name name;
  final FormzStatus status;

  @override
  List<Object> get props => [name, status,data];
  RemindersState copyWith({
    Name? name,
    FormzStatus? status,}) {
    return RemindersState(
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}
class ReminderInitial extends RemindersState {
}
class RemindersSubmitted extends RemindersState {
  final int result;
  RemindersSubmitted({required this.result});
}
class ReminderLoaded extends RemindersState {
   List<RemindersData> data;
  ReminderLoaded({required this.data});
}

class Error extends RemindersState {
  final String message;
  Error({required this.message});
}
class ReminderListFetchSuccess extends RemindersState {
   ReminderListFetchSuccess(List<RemindersData> data,) : super(data: data,);
}

class RemindersListFetchFailure extends RemindersState {
  final dynamic exception;
   RemindersListFetchFailure(List<RemindersData> data,
      this.exception,) : super(data: data);

  @override
  List<Object> get props => [exception.toString()];
}

class ReminderListFetching extends RemindersState {
  final bool isInitial;
   ReminderListFetching(List<RemindersData> data,
      this.isInitial,) : super(data: data,
  );
}