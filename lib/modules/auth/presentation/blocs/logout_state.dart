sealed class LogoutState {
  const LogoutState();

  const factory LogoutState.success() = LogoutSuccess;
  const factory LogoutState.error() = LogoutError;
  const factory LogoutState.loading() = LogoutLoading;
  const factory LogoutState.initial() = LogoutInitial;
}

class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}

class LogoutError extends LogoutState {
  const LogoutError();
}
