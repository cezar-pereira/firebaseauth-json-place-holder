import '../core.dart';

class QuantityMinimumValidator extends ValueObjectInterface {
  final int minimum;
  final String field;
  final String message;

  QuantityMinimumValidator({
    required this.minimum,
    this.field = '',
    this.message = '',
  }) : assert((field.isNotEmpty || message.isNotEmpty));
  @override
  String? validator(String value) {
    if (value.length < minimum) {
      return message.isEmpty
          ? 'Quantidade mínima de $field: $minimum'
          : message;
    } else {
      return null;
    }
  }
}
