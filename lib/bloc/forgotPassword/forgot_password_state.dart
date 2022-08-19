import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/validate_models/email.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final FormzStatus status;
  ForgotPasswordState copyWith({Email? email,
    FormzStatus? status,}) {
    return ForgotPasswordState(email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, status];
}