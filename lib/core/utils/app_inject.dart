import 'package:flutter_modular/flutter_modular.dart';

class AppInject {
  static B get<B extends Object>({String? key}) {
    return Modular.get<B>();
  }
}
