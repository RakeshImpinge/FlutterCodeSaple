import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/validate_models/email.dart';
import 'package:learn_shudh_gurbani/validate_models/name.dart';
import 'package:learn_shudh_gurbani/validate_models/password.dart';

class SignUpState extends Equatable {
   SignUpState({
     this.name = const Name.pure(),
     this.email = const Email.pure(),
     this.password = const Password.pure(),
     this.checked= false,
     this.status = FormzStatus.pure,
  });

  final Name name;
  final Email email;
  final Password password;
  final bool checked;
  final FormzStatus status;

  @override
  List<Object> get props => [
    name,
    email,
    password,
    checked,
    status
  ];
  SignUpState copyWith({
    Name? name,
    Email? email,
    Password? password,
    bool? checked,
    FormzStatus? status,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      checked: checked??this.checked,
    );
  }
}