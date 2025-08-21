import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/core.dart';
import 'modules/modules.dart';

class AppModule extends Module {
  final FirebaseAuth? authFirebase;

  AppModule({this.authFirebase});

  @override
  List<Module> get imports => [
    AuthModule(authFirebase: authFirebase ?? FirebaseAuth.instance),
  ];

  @override
  void routes(RouteManager r) {
    r.module(
      Modular.initialRoute,
      module: AuthModule(authFirebase: authFirebase ?? FirebaseAuth.instance),
    );
    r.module(
      Modular.initialRoute,
      module: PostModule(),
      guards: [AuthGuard(authRepository: AppInject.get<AuthRepository>())],
    );
  }
}
