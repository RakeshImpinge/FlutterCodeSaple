import 'package:flutter_bloc/flutter_bloc.dart';
import '../../validate_models/TextInputValidationError.dart';
import 'report_mistake_event.dart';
import 'report_mistake_state.dart';
import 'package:formz/formz.dart';

class ReportMistakeBloc extends Bloc<ReportMistakeEvent, ReportMistakeFormState> {
  ReportMistakeBloc() : super(const ReportMistakeFormState()) {
    on<GurbaniTukChanged>(_gurbaniTukChanged);
    on<TrackNameChanged>(_trackNameChanged);
    on<TrackDurationChanged>(_trackDurationChanged);
    on<AngChanged>(_angChanged);
    on<MessageChanged>(_messageChange);
  }

  @override
  void onTransition(
      Transition<ReportMistakeEvent, ReportMistakeFormState> transition) {
       print(transition);
    super.onTransition(transition);
  }

  void _gurbaniTukChanged(GurbaniTukChanged event ,Emitter<ReportMistakeFormState> emit){
    final selectedGurbaniTuk = TextInput.dirty(event.gurbaniTuk,);
    emit(state.copyWith(
      selectedGurbani: selectedGurbaniTuk,
      status: Formz.validate([
        state.selectedGurbani,
        state.ang,
        state.duration,
        state.trackName,
        state.message,
        selectedGurbaniTuk,
      ]),
    ));
  }

  void _trackNameChanged(TrackNameChanged event ,Emitter<ReportMistakeFormState> emit){
    final trackName = TextInput.dirty(event.trackName,);
    emit(state.copyWith(
      trackName: trackName,
      status: Formz.validate([
        state.selectedGurbani,
        state.ang,
        state.duration,
        state.trackName,
        state.message,
        trackName,
      ]),
    ));
  }
  void _trackDurationChanged(TrackDurationChanged event ,Emitter<ReportMistakeFormState> emit) {
    final duration = TextInput.dirty(event.duration.toString());
    emit(state.copyWith(
      duration: duration,
      status: Formz.validate([
        state.selectedGurbani,
        state.ang,
        state.duration,
        state.trackName,
        state.message,
        duration,
      ]),
    ));
  }
    void _angChanged(AngChanged event ,Emitter<ReportMistakeFormState> emit) {
      final ang = TextInput.dirty(event.ang.toString());
      emit(state.copyWith(
        ang: ang,
        status: Formz.validate([
          state.selectedGurbani,
          state.ang,
          state.duration,
          state.trackName,
          state.message,
          ang,
        ]),
      ));
    }
  void _messageChange(MessageChanged event ,Emitter<ReportMistakeFormState> emit) {
    final message = TextInput.dirty(event.message.toString());
    emit(state.copyWith(
      message: message,
      status: Formz.validate([
        state.selectedGurbani,
        state.ang,
        state.duration,
        state.trackName,
        state.message,
        message,
      ]),
    ));
  }
}