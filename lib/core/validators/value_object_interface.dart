abstract class ValueObjectInterface {
  String? validator(String value);
}

extension ValidatorListExtension on List<ValueObjectInterface> {
  String? validate(String? value) {
    for (final validator in this) {
      final error = validator.validator(value ?? '');
      if (error != null) return error;
    }
    return null;
  }
}
