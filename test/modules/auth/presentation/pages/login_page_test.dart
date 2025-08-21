import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oauth_json_place_holder/app_module.dart';
import 'package:oauth_json_place_holder/modules/modules.dart';

import '../../../../../integration_test/mocks.dart';

void main() {
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
  });

  testWidgets('Should render e-mail and password fields', (tester) async {
    Modular.bindModule(AppModule());
    Modular.bindModule(AuthModule(authFirebase: mockAuth));

    await tester.pumpWidget(MaterialApp(home: LoginPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(LoginPageKeys.txtEmail), findsOneWidget);
    expect(find.byKey(LoginPageKeys.txtPassword), findsOneWidget);
  });
}
