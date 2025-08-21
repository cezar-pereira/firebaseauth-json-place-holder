import 'package:firebase_auth/firebase_auth.dart';

import '../../auth.dart' as auth;
import '../../auth.dart';

abstract interface class AuthDatasource {
  Future<auth.User> loginWithEmailPassword(
    LoginWithEmailPasswordDtoRequest dto,
  );

  Future<void> logout();
  Future<auth.User> getCurrentUser();
}

class AuthFirebaseDatasourceImpl implements AuthDatasource {
  final FirebaseAuth _auth;

  AuthFirebaseDatasourceImpl(this._auth);

  @override
  Future<auth.User> loginWithEmailPassword(
    LoginWithEmailPasswordDtoRequest dto,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: dto.email,
        password: dto.password,
      );

      return auth.User(
        email: credential.user?.email ?? "",
        name: credential.user?.displayName ?? '',
        id: credential.user?.uid ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw switch (e.code) {
        'too-many-requests' => LoginState.manyFailedLoginAttempts(),
        'invalid-email' => LoginState.invalidEmail(),
        'user-disabled' => LoginState.userDisabled(),
        'INVALID_LOGIN_CREDENTIALS' => LoginState.unauthorized(),
        'user-not-found' => LoginState.unauthorized(),
        'invalid-credential' => LoginState.unauthorized(),
        _ => LoginState.error(message: e.message ?? ''),
      };
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<auth.User> getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user == null) throw AuthUnauthenticated();

      return auth.User(
        email: user.email ?? "",
        name: user.displayName ?? '',
        id: user.uid,
      );
    } catch (e) {
      rethrow;
    }
  }
}
