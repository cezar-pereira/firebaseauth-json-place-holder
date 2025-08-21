import 'package:bloc/bloc.dart';

import '../../auth.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit({
    required AuthRepository loginRepository,
    required AuthNotifier authNotifier,
  }) : _loginRepository = loginRepository,
       _authNotifier = authNotifier,
       super(const LogoutState.initial());

  final AuthRepository _loginRepository;
  final AuthNotifier _authNotifier;

  Future<void> logout() async {
    emit(const LogoutState.loading());

    final result = await _loginRepository.logout();
    result.fold(
      (e) {
        emit(e);
      },
      (user) {
        _authNotifier.unauthenticate();
        emit(LogoutState.success());
      },
    );
  }
}
