import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/modules/auth/auth.dart';

import '../../../../../integration_test/mocks.dart';

void main() {
  late LoginCubit cubit;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    cubit = LoginCubit(loginRepository: repository);
  });

  group('LoginCubit |', () {
    final user = User(id: 'id', name: 'name', email: 'email');
    const email = 'email';
    const password = 'password';
    const request = LoginWithEmailPasswordDtoRequest(
      email: 'email',
      password: 'password',
    );

    test('initial state is LoginInitial', () {
      expect(cubit.state, const LoginState.initial());
    });

    test(
      'Should emit Unauthorized when wrong credentials are provided',
      () async {
        when(
          () => repository.loginWithEmailPassword(request),
        ).thenAnswer((_) async => const Left(LoginUnauthorizedFailure()));
        await cubit.login(email: email, password: password);
        expect(cubit.state, isA<Unauthorized>());
      },
    );

    test(
      'Should emit LoginError when login fails with a generic error',
      () async {
        when(
          () => repository.loginWithEmailPassword(request),
        ).thenAnswer((_) async => const Left(LoginGenericFailure('error')));
        await cubit.login(email: email, password: password);
        expect(cubit.state, isA<LoginError>());
      },
    );

    test(
      'Should emit LoginError when login fails with a generic error',
      () async {
        when(
          () => repository.loginWithEmailPassword(request),
        ).thenAnswer((_) async => Right(user));
        await cubit.login(email: email, password: password);
        expect(cubit.state, isA<LoginSuccess>());
      },
    );
  });
}
