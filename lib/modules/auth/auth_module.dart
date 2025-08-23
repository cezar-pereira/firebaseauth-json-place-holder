import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oauth_json_place_holder/shared_module.dart';

import 'auth.dart';

class AuthModule extends Module {
  final FirebaseAuth? authFirebase;

  AuthModule({this.authFirebase});

  @override
  List<Module> get imports => [SharedModule(authFirebase: authFirebase)];

  @override
  void binds(i) {
    /* SERVICES */
    // i.addLazySingleton<AuthNotifier>(AuthNotifier.new);
    /* USECASES */
    /* CUBITS */
    i.add<LoginCubit>(LoginCubit.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(AuthRoutes.splash, child: (_) => const SplashPage());
    r.child(AuthRoutes.login, child: (_) => const LoginPage());
    r.child(AuthRoutes.userDetails, child: (_) => const UserDetailsPage());
  }
}
