import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends SignUpEvent {
  const NameChanged({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}
class UserNameUnfocused extends SignUpEvent {}

class EmailChanged extends SignUpEvent {
  const EmailChanged({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];
}
class EmailUnfocused extends SignUpEvent {}

class PasswordChanged extends SignUpEvent {
  const PasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}
class PasswordUnfocused extends SignUpEvent {}

class CheckBoxChanged extends SignUpEvent {
  const CheckBoxChanged({
    this.checked,
  });

  final bool? checked;

  @override
  List<Object> get props => [checked!];
}

class FormSubmitted extends SignUpEvent {}
