import 'package:flutter_modular/flutter_modular.dart';

import 'modules/modules.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    r.module(Modular.initialRoute, module: AuthModule());
    r.module(Modular.initialRoute, module: PostModule());
  }
}
