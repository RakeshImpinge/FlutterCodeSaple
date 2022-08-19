import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/validate_models/email.dart';
import 'package:learn_shudh_gurbani/validate_models/password.dart';

class LoginState extends Equatable {
  const LoginState({this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  LoginState copyWith({Email? email,
    Password? password,
    FormzStatus? status,}) {
    return LoginState(email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}