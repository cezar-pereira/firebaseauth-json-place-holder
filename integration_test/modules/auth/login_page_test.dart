import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/app_module.dart';
import 'package:oauth_json_place_holder/modules/modules.dart';
import 'package:oauth_json_place_holder/shared_module.dart';

import '../../mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockFirebaseAuth mockAuth;
  late MockAuthRepository mockAuthRepository;
  late LoginCubit loginCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginCubit = LoginCubit(loginRepository: mockAuthRepository);
    mockAuth = MockFirebaseAuth();
    Modular.bindModule(AppModule(authFirebase: mockAuth));
    Modular.bindModule(SharedModule(authFirebase: mockAuth));
    Modular.bindModule(AuthModule(authFirebase: mockAuth));
    Modular.replaceInstance<AuthRepository>(mockAuthRepository);
    Modular.replaceInstance<LoginCubit>(loginCubit);
  });

  tearDown(() async {
    reset(mockAuthRepository);
    loginCubit.close();
  });

  Future<void> enterCredentialsAndConfirm({
    required WidgetTester tester,
    required String email,
    required String password,
  }) async {
    final txtEmail = find.byKey(LoginPageKeys.txtEmail);
    final txtPassword = find.byKey(LoginPageKeys.txtPassword);
    final btnLogin = find.byKey(LoginPageKeys.btnLogin);

    expect(txtEmail, findsOneWidget);
    expect(txtPassword, findsOneWidget);
    expect(btnLogin, findsOneWidget);

    await tester.enterText(txtEmail, email);
    await tester.enterText(txtPassword, password);
    await tester.pumpAndSettle();
    await tester.tap(btnLogin);
    await tester.pumpAndSettle();
  }

  testWidgets('Should show message for unauthorized', (
    WidgetTester tester,
  ) async {
    final email = 'email@email.com';
    final password = 'password';

    final loginRequest = LoginWithEmailPasswordDtoRequest(
      email: email,
      password: password,
    );

    when(
      () => mockAuthRepository.loginWithEmailPassword(loginRequest),
    ).thenAnswer((_) async => const Left(LoginUnauthorizedFailure()));

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.pumpAndSettle();

    await enterCredentialsAndConfirm(
      tester: tester,
      email: email,
      password: password,
    );

    expect(find.text('E-mail e/ou senha incorretos'), findsOneWidget);
  });

  testWidgets('Should show generic message for LoginError', (
    WidgetTester tester,
  ) async {
    final email = 'email@email.com';
    final password = 'password';
    const messageError = 'Default error message';

    final loginRequest = LoginWithEmailPasswordDtoRequest(
      email: email,
      password: password,
    );

    when(
      () => mockAuthRepository.loginWithEmailPassword(loginRequest),
    ).thenAnswer((_) async => const Left(LoginGenericFailure(messageError)));

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.pumpAndSettle();

    await enterCredentialsAndConfirm(
      tester: tester,
      email: email,
      password: password,
    );

    expect(find.text(messageError), findsOneWidget);
  });

  testWidgets('Should validate e-mail and password', (
    WidgetTester tester,
  ) async {
    final navigator = ModularNavigateMock();
    Modular.navigatorDelegate = navigator;

    when(
      () => navigator.pushNamed(PostRoutes.posts),
    ).thenAnswer((_) => Future.value(null));

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.pumpAndSettle();

    //incorrect E-mail
    await enterCredentialsAndConfirm(
      tester: tester,
      email: 'testemail@',
      password: 'password',
    );
    expect(find.text('E-mail inválido'), findsOneWidget);

    //E-mail max length
    await enterCredentialsAndConfirm(
      tester: tester,
      email: List.generate(100, (index) => 'a').join(),
      password: 'password',
    );
    expect(find.text('Caracteres máximo: 77'), findsOneWidget);

    //E-mail required
    await enterCredentialsAndConfirm(
      tester: tester,
      email: '',
      password: 'password',
    );
    expect(find.text('Campo requerido'), findsOneWidget);

    // Password quantity minimum
    await enterCredentialsAndConfirm(
      tester: tester,
      email: 'email@email',
      password: '123',
    );
    expect(find.text('Quantidade mínima de Senha: 6'), findsOneWidget);

    verifyNever(() => navigator.pushNamed(PostRoutes.posts));
  });

  testWidgets('Should navigate to ${PostRoutes.posts} when success in login', (
    WidgetTester tester,
  ) async {
    final navigator = ModularNavigateMock();
    Modular.navigatorDelegate = navigator;
    final email = 'email@email.com';
    final password = '111111';

    final loginRequest = LoginWithEmailPasswordDtoRequest(
      email: email,
      password: password,
    );

    when(
      () => navigator.navigate(PostRoutes.posts),
    ).thenAnswer((_) => Future.value(null));

    when(
      () => mockAuthRepository.loginWithEmailPassword(loginRequest),
    ).thenAnswer((_) async {
      return Right(User(id: 'id', name: 'name', email: email));
    });

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.pumpAndSettle();

    await enterCredentialsAndConfirm(
      tester: tester,
      email: email,
      password: password,
    );

    verify(() => navigator.navigate(PostRoutes.posts)).called(1);
  });
}
