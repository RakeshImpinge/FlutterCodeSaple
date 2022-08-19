import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../validate_models/TextInputValidationError.dart';

class ReportMistakeFormState extends Equatable {
  const ReportMistakeFormState(  {
    this.selectedGurbani = const TextInput.pure(),
    this.ang = const TextInput.pure(),
    this.message = const TextInput.pure(),
    this.trackName = const TextInput.pure(),
    this.duration = const TextInput.pure(),
    this.status = FormzStatus.pure,
  });

  final TextInput selectedGurbani;
  final TextInput ang;
  final TextInput trackName;
  final TextInput message;
  final TextInput duration;
  final FormzStatus status;

  ReportMistakeFormState copyWith({
    TextInput? selectedGurbani,
    TextInput? ang,
    TextInput? trackName,
    TextInput? message,
    TextInput ?duration,
     FormzStatus? status,
  }) {
    return ReportMistakeFormState(
      selectedGurbani: selectedGurbani ?? this.selectedGurbani,
      ang: ang ?? this.ang,
      trackName: trackName ?? this.trackName,
      message: message ?? this.message,
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [selectedGurbani, ang, trackName, message, duration,status];
}