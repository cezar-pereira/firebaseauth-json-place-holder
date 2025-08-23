import '../../auth.dart';

extension AuthRepositoryFailureToLoginStateExtension on AuthRepositoryFailure {
  LoginState toLoginState() {
    return switch (this) {
      LoginUnauthorizedFailure() => const LoginState.unauthorized(),
      LoginManyFailedAttemptsFailure() =>
        const LoginState.manyFailedLoginAttempts(),
      LoginInvalidEmailFailure() => const LoginState.invalidEmail(),
      LoginUserDisabledFailure() => const LoginState.userDisabled(),
      LoginEmailNotVerifiedFailure() => const LoginState.emailNotVerified(),
      LoginGenericFailure() => LoginState.error(message: message),
      LoginFailure() => LoginState.error(message: message),
      _ => LoginState.error(message: message),
    };
  }
}

extension AuthRepositoryFailureToLogoutStateExtension on AuthRepositoryFailure {
  LogoutState toLogoutState() {
    return switch (this) {
      LogoutFailure() => LogoutState.error(),
      _ => LogoutState.error(),
    };
  }
}
