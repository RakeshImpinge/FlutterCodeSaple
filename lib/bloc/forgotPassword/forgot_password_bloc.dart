import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/bloc/forgotPassword/forgot_password_event.dart';
import 'package:learn_shudh_gurbani/bloc/forgotPassword/forgot_password_state.dart';
import 'package:learn_shudh_gurbani/validate_models/email.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<EmailUnfocused>(_onEmailUnfocused);
    on<FormSubmitted>(_onFormSubmitted);
  }


  @override
  void onTransition(
      Transition<ForgotPasswordEvent, ForgotPasswordState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  void _onEmailChanged(EmailChanged event, Emitter<ForgotPasswordState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(email: email.valid ? email : Email.pure(event.email),
      status: Formz.validate([email]),
    ));
  }

  void _onEmailUnfocused(EmailUnfocused event,
      Emitter<ForgotPasswordState> emit) {
    final email = Email.dirty(state.email.value.trim());
    emit(state.copyWith(email: email,
      status: Formz.validate([email]),
    ));
  }

  void _onFormSubmitted(FormSubmitted event,
      Emitter<ForgotPasswordState> emit) async {
    final email = Email.dirty(state.email.value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email]),
    ));
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    }
  }
}