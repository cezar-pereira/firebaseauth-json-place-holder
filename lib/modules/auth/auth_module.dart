import 'package:flutter_modular/flutter_modular.dart';

import 'auth.dart';
import 'auth_routes.dart';

class AuthModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(AuthRoutes.splash, child: (_) => const SplashPage());
    r.child(AuthRoutes.login, child: (_) => const LoginPage());
  }
}
