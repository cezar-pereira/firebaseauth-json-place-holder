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

        expect(result, isA<Right<LoginState, LoginSuccess>>());
      },
    );

    test(
      'should return a LoginState when datasource throws a LoginState exception',
      () async {
        final dto = LoginWithEmailPasswordDtoRequest(
          email: 'email',
          password: 'password',
        );
        when(
          () => datasource.loginWithEmailPassword(dto),
        ).thenThrow(const Unauthorized());

        final result = await repository.loginWithEmailPassword(dto);

        expect(result, isA<Left<LoginState, LoginSuccess>>());
        expect(result.fold((l) => l, (r) => r), isA<Unauthorized>());
      },
    );

    test(
      'should return a LoginError when datasource throws a generic exception',
      () async {
        final dto = LoginWithEmailPasswordDtoRequest(
          email: 'email',
          password: 'password',
        );
        when(
          () => datasource.loginWithEmailPassword(dto),
        ).thenThrow(Exception('error'));

        final result = await repository.loginWithEmailPassword(dto);

        expect(result, isA<Left<LoginState, LoginSuccess>>());
        expect(result.fold((l) => l, (r) => r), isA<LoginError>());
      },
    );
  });
}
