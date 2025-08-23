import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/modules/auth/auth.dart';

import '../../../../../integration_test/mocks.dart';

void main() {
  late AuthRepository repository;
  late AuthDatasource datasource;

  setUp(() {
    datasource = MockAuthDatasource();
    repository = AuthRepositoryImpl(datasource);
  });

  group('AuthRepositoryImpl |', () {
    test(
      'should return a LoginSuccess when datasource call is successful',
      () async {
        final user = User(id: 'id', name: 'name', email: 'email');
        final dto = LoginWithEmailPasswordDtoRequest(
          email: 'email',
          password: 'password',
        );
        when(
          () => datasource.loginWithEmailPassword(dto),
        ).thenAnswer((_) async => user);

        final result = await repository.loginWithEmailPassword(dto);

        expect(result, isA<Right<AuthRepositoryFailure, User>>());
      },
    );

    test(
      'should return a LoginUnauthorizedFailure when datasource throws an exception',
      () async {
        final dto = LoginWithEmailPasswordDtoRequest(
          email: 'email',
          password: 'password',
        );
        when(
          () => datasource.loginWithEmailPassword(dto),
        ).thenThrow(LoginUnauthorizedFailure());

        final result = await repository.loginWithEmailPassword(dto);

        expect(result, isA<Left<AuthRepositoryFailure, User>>());
        expect(
          result.fold((l) => l, (r) => r),
          isA<LoginUnauthorizedFailure>(),
        );
      },
    );

    test(
      'should return a LoginGenericFailure when datasource throws a generic exception',
      () async {
        final dto = LoginWithEmailPasswordDtoRequest(
          email: 'email',
          password: 'password',
        );
        when(
          () => datasource.loginWithEmailPassword(dto),
        ).thenThrow(LoginGenericFailure(''));

        final result = await repository.loginWithEmailPassword(dto);

        expect(result, isA<Left<AuthRepositoryFailure, User>>());
        expect(result.fold((l) => l, (r) => r), isA<LoginGenericFailure>());
      },
    );
  });
}
