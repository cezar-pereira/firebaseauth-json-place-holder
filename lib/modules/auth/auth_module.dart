import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_modular/flutter_modular.dart';

import 'auth.dart';

class AuthModule extends Module {
  final firebase.FirebaseAuth authFirebase;

  AuthModule({required this.authFirebase});

  @override
  void binds(i) {
    /* DATASOURCE */
    i.addInstance<AuthDatasource>(AuthFirebaseDatasourceImpl(authFirebase));
    /* REPOSITORIES */
    /* SERVICES */
    i.addLazySingleton<AuthNotifier>(AuthNotifier.new);
    /* USECASES */
    /* CONTROLLERS */
    i.addLazySingleton<LoginCubit>(LoginCubit.new);
    i.addLazySingleton<AuthRepository>(AuthRepositoryImpl.new);
    i.addLazySingleton<LogoutCubit>(LogoutCubit.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(AuthRoutes.splash, child: (_) => const SplashPage());
    r.child(AuthRoutes.login, child: (_) => const LoginPage());
  }
}
