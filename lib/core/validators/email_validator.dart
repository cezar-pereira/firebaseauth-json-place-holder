import 'package:oauth_json_place_holder/core/core.dart';

class EmailValidator extends ValueObjectInterface {
  @override
  String? validator(String value) {
    const lengthMax = 77;
    if (value.isNotEmpty) {
      if (value.length > lengthMax) {
        return 'Caracteres máximo: $lengthMax';
      }
      return value.isValidEmail ? null : 'E-mail inválido';
    } else {
      return null;
    }
  }
}
