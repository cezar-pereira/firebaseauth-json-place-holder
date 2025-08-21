import 'package:flutter_modular/flutter_modular.dart';
import 'package:oauth_json_place_holder/modules/modules.dart';

class AuthGuard extends RouteGuard {
  final AuthRepository authRepository;

  AuthGuard({required this.authRepository})
    : super(redirectTo: AuthRoutes.login);

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    return _isLoggedIn();
  }

  Future<bool> _isLoggedIn() async {
    final user = await authRepository.getCurrentUser();
    return user.isRight();
  }
}
