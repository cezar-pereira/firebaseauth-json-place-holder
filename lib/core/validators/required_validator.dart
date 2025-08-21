import '../core.dart';

class RequiredValidator extends ValueObjectInterface {
  final String? message;

  RequiredValidator({this.message});

  @override
  String? validator(String value) {
    return (value.isNotEmpty) ? null : message ?? 'Campo requerido';
  }
}
