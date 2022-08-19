import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/models/trackers_data.dart';
import 'package:learn_shudh_gurbani/validate_models/name.dart';

import '../../services/repository.dart';
import '../../strings.dart';
import 'trackers_event.dart';
import 'trackers_state.dart';

class TrackersBloc extends Bloc<TrackersEvent, TrackersState> {
  final Repository _repository;
  TrackersBloc(this._repository,[TrackersData? trackersData]) :super(TrackersInitial()) {
    on<NameChanged>(_TrackerNameChanged);
    on<TrackerNameUnfocused>(_onTrackerNameUnfocused);
    on<FormSubmitted>(_onFormSubmitted);
    on<TrackersSubmission>((event, emit) async {
      try {
        int data = await _repository.trackerSubmission(trackersData!);
        emit(TrackersSubmitted(data: data));
      } on Exception {
        emit(Error(message: Strings.unable_to_fetch_data));
      }
    });
  }
  @override
  void onTransition(Transition<TrackersEvent, TrackersState> transition) {
    super.onTransition(transition);
  }
  void _TrackerNameChanged(NameChanged event, Emitter<TrackersState> emit) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name.valid ? name : const Name.pure(),
      status: Formz.validate([name,]),
    ));
  }
  void _onTrackerNameUnfocused(TrackerNameUnfocused event, Emitter<TrackersState> emit) {
    final name = Name.dirty(state.name.value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([name]),
    ));
  }

  Future<void> _onFormSubmitted(FormSubmitted event, Emitter<TrackersState> emit) async {
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

