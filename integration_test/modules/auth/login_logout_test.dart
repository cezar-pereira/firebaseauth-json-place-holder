import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/app_module.dart';
import 'package:oauth_json_place_holder/app_widget.dart';
import 'package:oauth_json_place_holder/modules/modules.dart';
import 'package:oauth_json_place_holder/shared_module.dart';

import '../../mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login and logout Test |', () {
    late MockAuthRepository mockAuthRepository;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockPostRepository mockPostRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockFirebaseAuth = MockFirebaseAuth();
      mockPostRepository = MockPostRepository();

      // Setup modules
      Modular.bindModule(AppModule(authFirebase: mockFirebaseAuth));
      Modular.bindModule(SharedModule(authFirebase: mockFirebaseAuth));
      Modular.bindModule(AuthModule(authFirebase: mockFirebaseAuth));

      // Replace repository instances
      Modular.replaceInstance<AuthRepository>(mockAuthRepository);
      Modular.replaceInstance<PostRepository>(mockPostRepository);
    });

    tearDown(() {
      reset(mockAuthRepository);
      reset(mockFirebaseAuth);
      reset(mockPostRepository);
    });

    testWidgets(
      'Should complete full happy path flow: app start -> login -> posts -> user details -> logout',
      (WidgetTester tester) async {
        // Mock user data
        final testUser = User(
          id: 'user123',
          name: 'Test User',
          email: 'test@example.com',
          photoUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        );

        // Mock login request
        final loginRequest = LoginWithEmailPasswordDtoRequest(
          email: 'test@example.com',
          password: 'password123',
        );

        // Set mock firebase: AuthenticationUnauthenticatedFailure
        when(() => mockAuthRepository.getCurrentUser()).thenAnswer(
          (_) async => const Left(AuthenticationUnauthenticatedFailure()),
        );

        // Setup login success
        when(
          () => mockAuthRepository.loginWithEmailPassword(loginRequest),
        ).thenAnswer((_) async => Right(testUser));

        // Setup posts for PostsPage
        when(
          () => mockPostRepository.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => Right([]));

        // Setup logout success
        when(
          () => mockAuthRepository.logout(),
        ).thenAnswer((_) async => const Right(unit));

        // STEP 1: Start the app from AppWidget (main)
        await tester.pumpWidget(
          ModularApp(module: AppModule(), child: AppWidget()),
        );
        await tester.pumpAndSettle();

        // Wait for splash and auth check
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Should be on login page (AuthUnauthenticated state)
        expect(find.byType(LoginPage), findsOneWidget);

        final emailField = find.byKey(LoginPageKeys.txtEmail);
        final passwordField = find.byKey(LoginPageKeys.txtPassword);
        final loginButton = find.byKey(LoginPageKeys.btnLogin);

        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, 'password123');
        await tester.pumpAndSettle();

        // Mock user firebase
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));

        await tester.tap(loginButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should show PostsPage
        expect(find.byType(PostsPage), findsOneWidget);
        expect(find.text('LIST POSTS'), findsOneWidget);

        await tester.tap(find.byKey(PostPageKeys.btnPhotoUser));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(LoginPageKeys.btnLogout));
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsOneWidget);

        verify(
          () => mockAuthRepository.getCurrentUser(),
        ).called(greaterThan(1));
        verify(
          () => mockAuthRepository.loginWithEmailPassword(loginRequest),
        ).called(1);
        verify(() => mockAuthRepository.logout()).called(1);
      },
    );
  });
}
