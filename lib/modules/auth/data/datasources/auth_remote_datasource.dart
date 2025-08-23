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

      final user = credential.user;
      if (user == null) throw AuthUnauthenticated();

      return auth.User(
        id: user.uid,
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw switch (e.code) {
        'too-many-requests' => LoginManyFailedAttemptsFailure(),
        'invalid-email' => LoginInvalidEmailFailure(),
        'user-disabled' => LoginUserDisabledFailure(),
        'INVALID_LOGIN_CREDENTIALS' => LoginUnauthorizedFailure(),
        'user-not-found' => LoginUnauthorizedFailure(),
        'invalid-credential' => LoginUnauthorizedFailure(),
        _ => LoginGenericFailure(e.message ?? ''),
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
        email: user.email,
        name: user.displayName,
        id: user.uid,
        photoUrl: user.photoURL,
      );
    } catch (e) {
      rethrow;
    }
  }
}
