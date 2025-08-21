import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/modules/auth/auth.dart';

class MockFirebaseAuth extends Mock implements firebase.FirebaseAuth {}

class MockAuthRepository extends Mock implements AuthRepository {}

class ModularNavigateMock extends Mock implements IModularNavigator {}

class MockAuthDatasource extends Mock implements AuthDatasource {}
