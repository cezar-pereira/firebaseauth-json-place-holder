import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/core.dart';
import 'modules/auth/auth.dart';

class SharedModule extends Module {
  final FirebaseAuth? authFirebase;

  SharedModule({this.authFirebase});
  @override
  void exportedBinds(Injector i) {
    /* DATASOURCE */
    i.addInstance<AuthDatasource>(
      AuthFirebaseDatasourceImpl(authFirebase ?? FirebaseAuth.instance),
    );
    /* REPOSITORIES */
    i.addLazySingleton<AuthRepository>(AuthRepositoryImpl.new);
    /* SERVICES */
    i.addLazySingleton<AuthNotifier>(AuthNotifier.new);
    /* CUBITS */
    i.add<LogoutCubit>(LogoutCubit.new);
    i.addSingleton<RestClient>(AppClient.new);
    super.binds(i);
  }
}
