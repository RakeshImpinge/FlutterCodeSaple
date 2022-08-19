import 'package:formz/formz.dart';

enum PasswordValidationError {
  invalid,
  empty
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([String value = '']) : super.pure(value);
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp = RegExp(
      r'^[A-Za-z\d@$!%*?&]{8,}$'
  );

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}

extension Explanation on PasswordValidationError {
  Future<String?> get name async {
    switch(this) {
      case PasswordValidationError.invalid:
        return "Invalid password";
      case PasswordValidationError.empty:
        return "Password required";
      default:
        return null;
    }
  }
}