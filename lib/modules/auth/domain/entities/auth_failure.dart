sealed class AuthRepositoryFailure {
  final String message;
  const AuthRepositoryFailure(this.message);
}

// Login Failures
class LoginFailure extends AuthRepositoryFailure {
  const LoginFailure(super.message);
}

class LoginUnauthorizedFailure extends LoginFailure {
  const LoginUnauthorizedFailure() : super('E-mail e/ou senha incorretos');
}

class LoginManyFailedAttemptsFailure extends LoginFailure {
  const LoginManyFailedAttemptsFailure()
    : super('Muitas tentativas de login falharam. Tente novamente mais tarde');
}

class LoginInvalidEmailFailure extends LoginFailure {
  const LoginInvalidEmailFailure() : super('E-mail inválido');
}

class LoginUserDisabledFailure extends LoginFailure {
  const LoginUserDisabledFailure() : super('Usuário desabilitado');
}

class LoginEmailNotVerifiedFailure extends LoginFailure {
  const LoginEmailNotVerifiedFailure() : super('E-mail não verificado');
}

class LoginGenericFailure extends LoginFailure {
  const LoginGenericFailure(super.message);
}

// Logout Failures
class LogoutFailure extends AuthRepositoryFailure {
  const LogoutFailure(super.message);
}

class LogoutGenericFailure extends LogoutFailure {
  const LogoutGenericFailure(super.message);
}

// Authentication Failures
class AuthenticationFailure extends AuthRepositoryFailure {
  const AuthenticationFailure(super.message);
}

class AuthenticationUnauthenticatedFailure extends AuthenticationFailure {
  const AuthenticationUnauthenticatedFailure()
    : super('Usuário não autenticado');
}

class AuthenticationGenericFailure extends AuthenticationFailure {
  const AuthenticationGenericFailure(super.message);
}
