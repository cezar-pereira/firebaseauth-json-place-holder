import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/modules/auth/auth.dart';

import '../../../../../integration_test/mocks.dart';

void main() {
  late AuthFirebaseDatasourceImpl datasource;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    datasource = AuthFirebaseDatasourceImpl(mockFirebaseAuth);
  });

  final loginRequest = LoginWithEmailPasswordDtoRequest(
    email: 'test@example.com',
    password: 'password123',
  );

  final mockFirebaseUser = MockFirebaseUser();
  final mockUserCredential = MockUserCredential();

  final uuid = 'user123';
  final email = 'test@example.com';
  final name = 'Test User';
  final photoUrl = 'https://example.com/photo.jpg';

  setUp(() {
    when(() => mockFirebaseUser.uid).thenReturn(uuid);
    when(() => mockFirebaseUser.email).thenReturn(email);
    when(() => mockFirebaseUser.displayName).thenReturn(name);
    when(() => mockFirebaseUser.photoURL).thenReturn(photoUrl);

    when(() => mockUserCredential.user).thenReturn(mockFirebaseUser);
  });

  group('loginWithEmailPassword |', () {
    test('should return User when login is successful', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: loginRequest.email,
          password: loginRequest.password,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      final result = await datasource.loginWithEmailPassword(loginRequest);

      expect(
        result,
        User(id: uuid, email: email, name: name, photoUrl: photoUrl),
      );

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: loginRequest.email,
          password: loginRequest.password,
        ),
      ).called(1);
    });

    test(
      'should throw AuthUnauthenticated when user credential is null',
      () async {
        when(() => mockUserCredential.user).thenReturn(null);
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<AuthUnauthenticated>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test(
      'should throw LoginManyFailedAttemptsFailure when Firebase returns too-many-requests',
      () async {
        final firebaseException = firebase.FirebaseAuthException(
          code: 'too-many-requests',
          message: 'Too many failed attempts',
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenThrow(firebaseException);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<LoginManyFailedAttemptsFailure>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test(
      'should throw LoginInvalidEmailFailure when Firebase returns invalid-email',
      () async {
        final firebaseException = firebase.FirebaseAuthException(
          code: 'invalid-email',
          message: 'Invalid email format',
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenThrow(firebaseException);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<LoginInvalidEmailFailure>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test(
      'should throw LoginUserDisabledFailure when Firebase returns user-disabled',
      () async {
        final firebaseException = firebase.FirebaseAuthException(
          code: 'user-disabled',
          message: 'User account is disabled',
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenThrow(firebaseException);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<LoginUserDisabledFailure>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test(
      'should throw LoginUnauthorizedFailure when Firebase returns INVALID_LOGIN_CREDENTIALS',
      () async {
        final firebaseException = firebase.FirebaseAuthException(
          code: 'INVALID_LOGIN_CREDENTIALS',
          message: 'Invalid credentials',
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenThrow(firebaseException);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<LoginUnauthorizedFailure>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test(
      'should throw LoginUnauthorizedFailure when Firebase returns user-not-found',
      () async {
        final firebaseException = firebase.FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenThrow(firebaseException);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<LoginUnauthorizedFailure>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test(
      'should throw LoginUnauthorizedFailure when Firebase returns invalid-credential',
      () async {
        final firebaseException = firebase.FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Invalid credential',
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenThrow(firebaseException);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<LoginUnauthorizedFailure>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test(
      'should throw LoginGenericFailure when Firebase returns unknown error code',
      () async {
        final firebaseException = firebase.FirebaseAuthException(
          code: 'unknown-error',
          message: 'Unknown error occurred',
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenThrow(firebaseException);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<LoginGenericFailure>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test(
      'should throw LoginGenericFailure with empty message when Firebase returns null message',
      () async {
        final firebaseException = firebase.FirebaseAuthException(
          code: 'unknown-error',
          message: null,
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).thenThrow(firebaseException);

        expect(
          () => datasource.loginWithEmailPassword(loginRequest),
          throwsA(isA<LoginGenericFailure>()),
        );

        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email,
            password: loginRequest.password,
          ),
        ).called(1);
      },
    );

    test('should handle different email and password combinations', () async {
      final differentRequest = LoginWithEmailPasswordDtoRequest(
        email: 'another@example.com',
        password: 'differentpass',
      );

      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: differentRequest.email,
          password: differentRequest.password,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      final result = await datasource.loginWithEmailPassword(differentRequest);

      expect(result, isA<User>());
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: differentRequest.email,
          password: differentRequest.password,
        ),
      ).called(1);
    });

    test('should rethrow non-FirebaseAuthException errors', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: loginRequest.email,
          password: loginRequest.password,
        ),
      ).thenThrow(Exception('Generic error'));

      expect(
        () => datasource.loginWithEmailPassword(loginRequest),
        throwsA(isA<Exception>()),
      );

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: loginRequest.email,
          password: loginRequest.password,
        ),
      ).called(1);
    });
  });

  group('logout |', () {
    test('should call Firebase signOut successfully', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await datasource.logout();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('should rethrow errors from Firebase signOut', () async {
      when(
        () => mockFirebaseAuth.signOut(),
      ).thenThrow(Exception('Logout failed'));

      expect(() => datasource.logout(), throwsA(isA<Exception>()));

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
  });

  group('getCurrentUser |', () {
    test('should return User when current user exists', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);

      final result = await datasource.getCurrentUser();

      expect(result, isA<User>());
      expect(result.id, uuid);
      expect(result.email, email);
      expect(result.name, name);
      expect(result.photoUrl, photoUrl);

      verify(() => mockFirebaseAuth.currentUser).called(1);
    });

    test(
      'should throw AuthUnauthenticated when current user is null',
      () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        expect(
          () => datasource.getCurrentUser(),
          throwsA(isA<AuthUnauthenticated>()),
        );

        verify(() => mockFirebaseAuth.currentUser).called(1);
      },
    );

    test('should rethrow errors from Firebase currentUser', () async {
      when(
        () => mockFirebaseAuth.currentUser,
      ).thenThrow(Exception('Get user failed'));

      expect(() => datasource.getCurrentUser(), throwsA(isA<Exception>()));

      verify(() => mockFirebaseAuth.currentUser).called(1);
    });

    test('should handle user with null displayName and photoURL', () async {
      when(() => mockFirebaseUser.displayName).thenReturn(null);
      when(() => mockFirebaseUser.photoURL).thenReturn(null);
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);

      final result = await datasource.getCurrentUser();

      expect(result, isA<User>());
      expect(result.id, uuid);
      expect(result.email, email);
      expect(result.name, isNull);
      expect(result.photoUrl, isNull);

      verify(() => mockFirebaseAuth.currentUser).called(1);
    });
  });
}
