import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/modules/auth/auth.dart';
import 'package:oauth_json_place_holder/modules/post/post.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class ModularNavigateMock extends Mock implements IModularNavigator {}

class MockAuthDatasource extends Mock implements AuthDatasource {}

class MockPostRepository extends Mock implements PostRepository {}

// Mock classes for Firebase Auth
class MockFirebaseUser extends Mock implements firebase.User {}

class MockFirebaseAuth extends Mock implements firebase.FirebaseAuth {}

class MockUserCredential extends Mock implements firebase.UserCredential {}
