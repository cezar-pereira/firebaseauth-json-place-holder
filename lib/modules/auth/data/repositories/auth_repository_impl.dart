import 'package:fpdart/fpdart.dart';

import '../../auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<AuthRepositoryFailure, User>> loginWithEmailPassword(
    LoginWithEmailPasswordDtoRequest dto,
  ) async {
    try {
      final result = await _dataSource.loginWithEmailPassword(dto);
      return Right(result);
    } on AuthRepositoryFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(LoginFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthRepositoryFailure, Unit>> logout() async {
    try {
      await _dataSource.logout();
      return Right(unit);
    } catch (e) {
      return Left(LogoutGenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthRepositoryFailure, User>> getCurrentUser() async {
    try {
      final result = await _dataSource.getCurrentUser();
      return Right(result);
    } catch (e) {
      return const Left(AuthenticationUnauthenticatedFailure());
    }
  }
}
