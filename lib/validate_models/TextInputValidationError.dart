 import 'package:formz/formz.dart';

enum TextInputValidationError {
  invalid,
  mismatch,
}

class TextInput extends FormzInput<String, TextInputValidationError> {
  const TextInput.pure([String value = '']) : super.pure(value);
  const TextInput.dirty([String value = '']) : super.dirty(value);


  @override
  TextInputValidationError? validator(String value) {
    if (value.isEmpty) {
      return TextInputValidationError.invalid;
    }

  }
}

extension Explanation on TextInputValidationError {
  String? get name {
    switch(this) {
      case TextInputValidationError.invalid:
        return 'passwords must match';
      default:
        return null;
    }
  }
}