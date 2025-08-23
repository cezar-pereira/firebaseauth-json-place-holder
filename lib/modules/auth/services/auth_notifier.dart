import 'package:bloc/bloc.dart';
import '../auth.dart';

class AuthNotifier extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthInitial());

  Future<void> init() async {
    emit(AuthLoading());

    final user = await _authRepository.getCurrentUser();
    await Future.delayed(Duration(seconds: 1));

    user.fold(
      (failure) {
        if (failure is AuthenticationUnauthenticatedFailure) {
          emit(AuthUnauthenticated());
        } else {
          emit(AuthFailure(failure.message));
        }
      },
      (user) {
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  void authenticate(User user) {
    emit(AuthAuthenticated(user: user));
  }

  void unauthenticate() {
    emit(AuthUnauthenticated());
  }
}
