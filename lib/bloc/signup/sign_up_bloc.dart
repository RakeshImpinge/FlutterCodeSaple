import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/validate_models/email.dart';
import 'package:learn_shudh_gurbani/validate_models/name.dart';
import 'package:learn_shudh_gurbani/validate_models/password.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super( SignUpState()) {
    on<NameChanged>(_onUserNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<CheckBoxChanged>(_onCheckBoxChanged);
    on<EmailUnfocused>(_onEmailUnfocused);
    on<UserNameUnfocused>(_onUsernameUnfocused);
    on<PasswordUnfocused>(_onPasswordUnfocused);
    on<FormSubmitted>(_onFormSubmitted);
  }

  @override
  void onTransition(Transition<SignUpEvent, SignUpState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onUserNameChanged(NameChanged event, Emitter<SignUpState> emit) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name.valid ? name : const Name.pure(),
      status: Formz.validate([
        name,
        state.email,
        state.password,
      ]),
    ));
  }
  void _onEmailChanged(EmailChanged event, Emitter<SignUpState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email.valid ? email : const Email.pure(),
      status: Formz.validate([
        state.name,
        email,
        state.password,
      ]),
    ));
  }
  void _onPasswordChanged(PasswordChanged event, Emitter<SignUpState> emit) {
    final password = Password.dirty(event.password);
    emit( state.copyWith(
      password: password.valid ? password : const Password.pure(),
      status: Formz.validate([
        state.name,
        state.email,
        password,
      ]),
    ));
  }

  void _onCheckBoxChanged(CheckBoxChanged event, Emitter<SignUpState> emit) {
    final _checked = event.checked;
    emit( state.copyWith(
      checked: _checked,
      status: Formz.validate([
        state.name,
        state.email,
        state.password,
      ]),
    ));
  }
  void _onEmailUnfocused(EmailUnfocused event, Emitter<SignUpState> emit) {
    final email = Email.dirty(state.email.value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email,  state.name,state.password]),
    ));
  }
  void _onUsernameUnfocused(UserNameUnfocused event, Emitter<SignUpState> emit) {
    final name = Name.dirty(state.name.value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([name,state.email, state.password]),
    ));
  }

  void _onPasswordUnfocused(PasswordUnfocused event,
      Emitter<SignUpState> emit,
      ) {
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email,state.name, password]),
    ));
  }

  Future<void> _onFormSubmitted(FormSubmitted event, Emitter<SignUpState> emit) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(
      status: Formz.validate([state.email,state.name, state.password]),
    ));
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit( state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit( state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}

