import '../../auth.dart';

sealed class LoginState {
  const LoginState();
  const factory LoginState.initial() = LoginInitial;
  const factory LoginState.loading() = LoginLoading;
  const factory LoginState.success({required User user}) = LoginSuccess;
  const factory LoginState.error({required String message}) = LoginError;
  const factory LoginState.unauthorized() = Unauthorized;
  const factory LoginState.manyFailedLoginAttempts() = ManyFailedLoginAttempts;
  const factory LoginState.invalidEmail() = InvalidEmail;
  const factory LoginState.userDisabled() = UserDisabled;
  const factory LoginState.emailNotVerified() = EmailNotVerified;
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final User user;
  const LoginSuccess({required this.user});
}

class LoginError extends LoginState {
  final String message;
  const LoginError({required this.message});
}

class Unauthorized extends LoginState {
  const Unauthorized();
}

class ManyFailedLoginAttempts extends LoginState {
  const ManyFailedLoginAttempts();
}

class InvalidEmail extends LoginState {
  const InvalidEmail();
}

class UserDisabled extends LoginState {
  const UserDisabled();
}

class EmailNotVerified extends LoginState {
  const EmailNotVerified();
}
