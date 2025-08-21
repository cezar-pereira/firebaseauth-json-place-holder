import 'package:bloc/bloc.dart';

import '../../auth.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository loginRepository})
    : _loginRepository = loginRepository,
      super(const LoginState.initial());

  final AuthRepository _loginRepository;

  Future<void> login({required String email, required String password}) async {
    emit(const LoginState.loading());
    final request = LoginWithEmailPasswordDtoRequest(
      email: email,
      password: password,
    );
    final result = await _loginRepository.loginWithEmailPassword(request);
    result.fold(
      (e) {
        emit(e);
      },
      (user) {
        emit(user);
      },
    );
  }
}
