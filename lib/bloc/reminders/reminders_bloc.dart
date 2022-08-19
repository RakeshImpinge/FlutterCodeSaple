import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/models/create_reminders_data.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/validate_models/name.dart';
import '../../services/repository.dart';
import 'reminders_event.dart';
import 'reminders_state.dart';

class RemindersBloc extends Bloc<RemindersEvent, RemindersState> {
  final Repository _repository;
  RemindersBloc(this._repository,[RemindersData? remindersData]) :super(ReminderInitial()) {
    on<NameChanged>(_ReminderNameChanged);
    on<ReminderNameUnfocused>(_onReminderNameUnfocused);
    on<FormSubmitted>(_onFormSubmitted);
    on<ReminderSubmission>((event, emit) async {
      try {
        int data = await _repository.reminderSubmission(remindersData!);
        if(data==1) {
          emit(ReminderListFetching(state.data, (state is ReminderInitial)));
          List<RemindersData> result = await _repository.getReminderList();
          final data = [...state.data, ...result];
          emit(ReminderListFetchSuccess(data));
        }else {
          emit(RemindersSubmitted(result: data));
       }
      } on Exception {
        emit(Error(message: "Couldn't save reminder, please try again later!"));
      }
    });
    on<RefreshData>((event, emit) async {
      //try {
         // emit(ReminderListFetching(state.data, (state is ReminderInitial)));
          List<RemindersData> result = await _repository.getReminderList();
          final data = [...state.data, ...result];
          print("test>>${result.length}");
          emit(ReminderListFetchSuccess(result));

      // } on Exception {
      //   emit(Error(message: "Unable to update reminder, please try again later!"));
      // }
    });
    //ReminderStatusUpdated
    on<ReminderStatusUpdated>((event, emit) async {
      try {
        int responseCode = await _repository.updateReminderStatus(remindersData!);
        if(responseCode==1){
            emit(ReminderListFetching(state.data, (state is ReminderInitial)));
            List<RemindersData> result = await _repository.getReminderList();
            final data = [...state.data, ...result];
            emit(ReminderListFetchSuccess(data));
        }else{
          emit(Error(message: "Unable to update reminder, please try again later!"));
        }
      } on Exception {
        emit(Error(message: "Unable to update reminder, please try again later!"));
      }
    });
    on<ArchiveReminder>((event, emit) async {
      try {
        int responseCode = await _repository.deleteRecord(remindersData!.id!,Strings.reminders);
        if(responseCode==1){
          emit(ReminderListFetching(state.data, (state is ReminderInitial)));
          List<RemindersData> result = await _repository.getReminderList();
          final data = [...state.data, ...result];
          emit(ReminderListFetchSuccess(data));
        }else{
          emit(Error(message: "Unable to archive reminder, please try again later!"));
        }
      } on Exception {
        emit(Error(message: "Unable to archive reminder, please try again later!"));
      }
    });
    on<ReminderListFetched>(
          (event, emit) async {
        try {
          emit(ReminderListFetching(state.data, (state is ReminderInitial)));
          List<RemindersData> result = await _repository.getReminderList();
          final data = [...state.data, ...result];
          print("data>>${data.length}");
          emit(ReminderListFetchSuccess(data));
        } catch (e) {
          emit(RemindersListFetchFailure(
            state.data,
            e,
          ));
        }
      },
    );
  }
  @override
  void onTransition(Transition<RemindersEvent, RemindersState> transition) {
    super.onTransition(transition);
  }
  void _ReminderNameChanged(NameChanged event, Emitter<RemindersState> emit) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name.valid ? name : const Name.pure(),
      status: Formz.validate([
        name,
      ]),
    ));
  }
  void _onReminderNameUnfocused(ReminderNameUnfocused event, Emitter<RemindersState> emit) {
    final name = Name.dirty(state.name.value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([name]),
    ));
  }

  Future<void> _onFormSubmitted(FormSubmitted event, Emitter<RemindersState> emit) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit( state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit( state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}



