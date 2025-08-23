import 'package:fpdart/fpdart.dart';

import '../../auth.dart';

abstract interface class AuthRepository {
  Future<Either<AuthRepositoryFailure, User>> loginWithEmailPassword(
    LoginWithEmailPasswordDtoRequest dto,
  );
  Future<Either<AuthRepositoryFailure, Unit>> logout();
  Future<Either<AuthRepositoryFailure, User>> getCurrentUser();
}
