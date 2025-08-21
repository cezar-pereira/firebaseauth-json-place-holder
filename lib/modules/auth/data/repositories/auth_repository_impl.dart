import 'package:fpdart/fpdart.dart';

import '../../auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<LoginState, LoginSuccess>> loginWithEmailPassword(
    LoginWithEmailPasswordDtoRequest dto,
  ) async {
    try {
      final result = await _dataSource.loginWithEmailPassword(dto);
      return Right(LoginSuccess(user: result));
    } on LoginState catch (e) {
      return Left(e);
    } catch (e) {
      return Left(LoginState.error(message: e.toString()));
    }
  }

  @override
  Future<Either<LogoutState, Unit>> logout() async {
    try {
      await _dataSource.logout();
      return Right(unit);
    } on LogoutState catch (e) {
      return Left(e);
    } catch (e) {
      return Left(LogoutState.error());
    }
  }

  @override
  Future<Either<AuthUnauthenticated, AuthAuthenticated>>
  getCurrentUser() async {
    try {
      final result = await _dataSource.getCurrentUser();
      return Right(AuthAuthenticated(user: result));
    } catch (e) {
      return Left(AuthUnauthenticated());
    }
  }
}
