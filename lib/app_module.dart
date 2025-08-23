import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oauth_json_place_holder/shared_module.dart';

import 'core/core.dart';
import 'modules/modules.dart';

class AppModule extends Module {
  final FirebaseAuth? authFirebase;

  AppModule({this.authFirebase});

  @override
  List<Module> get imports => [SharedModule(authFirebase: authFirebase)];

  @override
  void routes(RouteManager r) {
    r.module(Modular.initialRoute, module: AuthModule());
    r.module(
      Modular.initialRoute,
      module: PostModule(),
      guards: [AuthGuard(authRepository: AppInject.get<AuthRepository>())],
    );
  }
}
