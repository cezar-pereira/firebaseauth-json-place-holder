import 'package:fpdart/fpdart.dart';

import '../../auth.dart';

abstract interface class AuthRepository {
  Future<Either<LoginState, LoginSuccess>> loginWithEmailPassword(
    LoginWithEmailPasswordDtoRequest dto,
  );
  Future<Either<LogoutState, Unit>> logout();
  Future<Either<AuthUnauthenticated, AuthAuthenticated>> getCurrentUser();
}
